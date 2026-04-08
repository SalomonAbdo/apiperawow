package middleware

import (
	"os"

	"github.com/gin-gonic/gin"
)

// AuthMiddleware verifica que la petición incluya la API_KEY correcta
func AuthMiddleware() gin.HandlerFunc {
	// Leemos la clave desde el entorno una sola vez al iniciar
	apiKey := os.Getenv("API_KEY")

	return func(c *gin.Context) {
		// Buscamos la clave en el Header 'X-API-Key'
		clientKey := c.GetHeader("X-API-Key")

		if clientKey == "" || clientKey != apiKey {
			c.AbortWithStatusJSON(401, gin.H{
				"error": "No autorizado: API Key inválida o ausente",
			})
			return
		}

		c.Next()
	}
}
