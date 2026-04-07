package main

import (
	"ac-api/database"
	"ac-api/handlers"
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	fmt.Println("🚀 Iniciando conexión con AzerothCore...")

	db, err := database.Connect()
	if err != nil {
		// Si el ping falla, el programa se detendrá aquí con el error detallado
		log.Fatalf("❌ ERROR CRÍTICO: No se pudo conectar a la DB: %v", err)
	}

	fmt.Println("✅ ¡Ping exitoso! Conexión establecida con acore_auth.")

	r := gin.Default()

	// Ruta de registro de usuarios
	r.POST("/api/accounts", handlers.CreateAccount(db))

	fmt.Println("🌐 API corriendo en http://localhost:8080")
	r.Run(":8080")
}
