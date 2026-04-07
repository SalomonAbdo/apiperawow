package handlers

import (
	"ac-api/models"
	"ac-api/srp6"
	"strings"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func CreateAccount(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req struct {
			Username string `json:"username" binding:"required,min=3,max=32"`
			Password string `json:"password" binding:"required,min=6"`
			Email    string `json:"email"    binding:"required,email"`
		}

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(400, gin.H{"error": err.Error()})
			return
		}

		salt, verifier, err := srp6.MakeRegistrationData(req.Username, req.Password)
		if err != nil {
			c.JSON(500, gin.H{"error": "Error de cifrado"})
			return
		}

		account := models.Account{
			Username:  strings.ToUpper(req.Username),
			Salt:      salt,
			Verifier:  verifier,
			Email:     req.Email,
			RegMail:   req.Email,
			Expansion: 2,
		}

		if err := db.Create(&account).Error; err != nil {
			c.JSON(409, gin.H{"error": "El usuario ya existe"})
			return
		}

		c.JSON(201, gin.H{"message": "¡Cuenta creada!"})
	}
}
