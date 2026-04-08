package main

import (
	"ac-api/database"
	"ac-api/handlers"
	"ac-api/middleware"
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	fmt.Println("🚀 Iniciando Backend WoWpera para AzerothCore 3.3.5a...")

	// 1. Cargar variables de entorno desde .env
	// Asegura que las credenciales de DB y la API_KEY estén disponibles
	err := godotenv.Load()
	if err != nil {
		log.Println("⚠️ Aviso: No se encontró el archivo .env, se usarán variables del sistema")
	}

	// 2. Conectar a la base de datos MySQL (acore_auth)
	// Realiza un Ping para validar que el servidor de WoW responde
	db, err := database.Connect()
	if err != nil {
		log.Fatalf("❌ ERROR CRÍTICO: Falló la conexión con la base de datos: %v", err)
	}

	fmt.Println("✅ Conexión exitosa con AzerothCore (acore_auth).")

	// 3. Configurar el motor de Gin
	r := gin.Default()

	// 4. Aplicar Middleware Global de CORS
	// Permite que tu frontend en Next.js (puerto 3000) hable con esta API
	r.Use(middleware.CORSMiddleware())

	// 5. Definir Grupo de Rutas Protegidas bajo /api
	// Todas estas rutas requieren la cabecera 'X-API-Key'
	api := r.Group("/api", middleware.AuthMiddleware())
	{
		// REGISTRO: Creación de cuentas nuevas con SRP6
		api.POST("/accounts", handlers.CreateAccount(db))

		// LOGIN: Validación de credenciales para NextAuth
		api.POST("/login", handlers.LoginAccount(db))

		// UTILIDAD: Verificar si un email ya tiene cuenta vinculada
		api.GET("/accounts/check/:email", handlers.CheckAccountByEmail(db))
	}

	// 6. Lanzar el servidor
	fmt.Println("🌐 API protegida escuchando en http://localhost:8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatalf("❌ No se pudo iniciar el servidor: %v", err)
	}
}
