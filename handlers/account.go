package handlers

import (
	"ac-api/models"
	"ac-api/srp6" // Tu paquete personalizado de SRP6
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

// 4. DASHBOARD: Resumen de estadísticas del jugador
func GetDashboardSummary(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		accountID := c.Param("id")

		var result struct {
			Status      string
			Rank        string
			CharCount   int64
			TotalOnline string
		}

		// Rango (GM Level)
		var gmLevel int
		db.Table("account_access").Where("id = ?", accountID).Select("gmlevel").Scan(&gmLevel)
		result.Rank = "Jugador"
		if gmLevel > 0 {
			result.Rank = "Staff / GM"
		}

		// Estatus de Baneo
		var banCount int64
		db.Table("account_banned").Where("id = ? AND active = 1", accountID).Count(&banCount)
		result.Status = "Activa"
		if banCount > 0 {
			result.Status = "Baneada"
		}

		// Conteo de personajes (Asumiendo que la DB de characters es accesible)
		// Si usas bases de datos separadas, asegúrate de que el usuario de MySQL tenga permisos en ambas
		db.Table("characters.characters").Where("account = ?", accountID).Count(&result.CharCount)

		var totalSeconds int64
		db.Table("characters.characters").Where("account = ?", accountID).Select("SUM(totaltime)").Scan(&totalSeconds)
		result.TotalOnline = fmt.Sprintf("%dh", totalSeconds/3600)

		c.JSON(http.StatusOK, result)
	}
}
