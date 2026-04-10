package handlers

import (
	"ac-api/models"
	"ac-api/srp6"
	"bytes"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// 1. REGISTRO: Crea una cuenta nueva con SRP6
func CreateAccount(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req struct {
			Username string `json:"username"`
			Password string `json:"password"`
			Email    string `json:"email"`
		}

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Datos inválidos"})
			return
		}

		// AzerothCore requiere el username en MAYÚSCULAS
		usernameUpper := strings.ToUpper(req.Username)

		// Generamos Salt y Verifier usando tu librería SRP6
		salt, verifier, err := srp6.MakeRegistrationData(usernameUpper, req.Password)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error al generar seguridad SRP6"})
			return
		}

		account := models.Account{
			Username: usernameUpper,
			Salt:     salt,
			Verifier: verifier,
			Email:    req.Email,
		}

		if err := db.Create(&account).Error; err != nil {
			c.JSON(http.StatusConflict, gin.H{"error": "El usuario o email ya existe"})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"message": "Cuenta creada exitosamente"})
	}
}

// 2. LOGIN: Valida credenciales para NextAuth usando el Salt de la DB
func LoginAccount(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req struct {
			Username string `json:"username"`
			Password string `json:"password"`
		}

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Formato inválido"})
			return
		}

		var account models.Account
		usernameUpper := strings.ToUpper(req.Username)

		// Buscamos al usuario
		if err := db.Where("username = ?", usernameUpper).First(&account).Error; err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Usuario no encontrado"})
			return
		}

		// RE-CALCULAMOS EL VERIFIER:
		// Usamos el Salt que ya tenemos en la base de datos para este usuario
		// El cálculo es: v = g^(SHA1(salt | SHA1(user:pass))) mod N
		testVerifier, err := srp6.CalculateVerifier(usernameUpper, req.Password, account.Salt)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error en el cálculo de seguridad"})
			return
		}

		// Comparación binaria de los Verifiers
		if !bytes.Equal(testVerifier, account.Verifier) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Contraseña incorrecta"})
			return
		}

		// Éxito: Devolvemos los datos que NextAuth guardará en el JWT
		c.JSON(http.StatusOK, gin.H{
			"id":       account.ID,
			"username": account.Username,
			"email":    account.Email,
		})
	}
}

// 3. CHECK: Utilidad para verificar existencia por email
func CheckAccountByEmail(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		email := c.Param("email")
		var account models.Account

		if err := db.Where("email = ?", email).First(&account).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"exists": false})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"exists":   true,
			"username": account.Username,
		})
	}
}

// GetUserCharacters obtiene la lista real de personajes desde acore_characters
func GetUserCharacters(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// 1. Obtenemos el ID de la cuenta desde la URL (:id)
		accountID := c.Param("id")

		if accountID == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "ID de cuenta requerido"})
			return
		}

		var characters []models.Character

		// 2. Ejecutamos la consulta filtrando por la columna 'account' (según tu DDL)
		// Ordenamos por nivel descendente (los más fuertes arriba)
		result := db.Where("account = ?", accountID).Order("level DESC").Find(&characters)

		// 3. Manejo de errores de base de datos
		if result.Error != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Error al recuperar personajes del reino"})
			return
		}

		// 4. Retornamos la lista (vacía o con datos)
		c.JSON(http.StatusOK, characters)
	}
}

// GetDashboardSummary recolecta métricas de Auth y Characters simultáneamente
func GetDashboardSummary(authDB *gorm.DB, charsDB *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		accountID := c.Param("id")

		var result struct {
			Status      string `json:"status"`
			Rank        string `json:"rank"`
			CharCount   int64  `json:"char_count"`
			TotalOnline string `json:"total_online"`
		}

		// --- SECCIÓN AUTH (Basado en tu DDL de account_access y account_banned) ---

		// 1. Obtener Rango (GM Level)
		var gmLevel uint8
		// Nota: id en account_access es el AccountID según tu DDL
		err := authDB.Table("account_access").
			Where("id = ?", accountID).
			Select("gmlevel").
			Scan(&gmLevel).Error

		if err != nil || gmLevel == 0 {
			result.Rank = "Jugador"
		} else {
			// Podrías mapear niveles (1: Moderador, 2: GM, 3: Admin)
			result.Rank = "Staff / GM"
		}

		// 2. Verificar Baneo Activo
		var banCount int64
		// Según tu DDL: active = 1 significa que el ban está vigente
		authDB.Table("account_banned").
			Where("id = ? AND active = 1", accountID).
			Count(&banCount)

		result.Status = "Activa"
		if banCount > 0 {
			result.Status = "Baneada"
		}

		// --- SECCIÓN CHARACTERS (Basado en tu DDL de characters) ---

		// 3. Contar personajes vinculados a la cuenta
		charsDB.Table("characters").
			Where("account = ?", accountID).
			Count(&result.CharCount)

		// 4. Calcular tiempo total de juego (totaltime está en segundos)
		var totalSeconds int64
		charsDB.Table("characters").
			Where("account = ?", accountID).
			Select("SUM(totaltime)").
			Scan(&totalSeconds)

		// Un toque de ingeniería: si totalSeconds es 0, evitamos cálculos
		if totalSeconds > 0 {
			result.TotalOnline = fmt.Sprintf("%dh", totalSeconds/3600)
		} else {
			result.TotalOnline = "0h"
		}

		c.JSON(http.StatusOK, result)
	}
}