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
	err := godotenv.Load()
	if err != nil {
		log.Println("⚠️ Aviso: No se encontró el archivo .env, se usarán variables del sistema")
	}

	// 2. Conectar a la base de datos de CUENTAS (acore_auth)
	// Usamos la clave "DB_NAME_AUTH" definida en tu .env
	authDB, err := database.Connect("DB_NAME_AUTH")
	if err != nil {
		log.Fatalf("❌ ERROR CRÍTICO (Auth): %v", err)
	}
	fmt.Println("✅ Conexión exitosa con AzerothCore (acore_auth).")

	// 3. Conectar a la base de datos de PERSONAJES (acore_characters)
	// Usamos la clave "DB_NAME_CHARS" definida en tu .env
	charsDB, err := database.Connect("DB_NAME_CHARS")
	if err != nil {
		log.Fatalf("❌ ERROR CRÍTICO (Characters): %v", err)
	}
	fmt.Println("✅ Conexión exitosa con AzerothCore (acore_characters).")

	// 4. Configurar el motor de Gin
	r := gin.Default()

	// 5. Aplicar Middleware Global de CORS
	r.Use(middleware.CORSMiddleware())

	// 6. Definir Grupo de Rutas bajo /api
	api := r.Group("/api")
	{
		// --- RUTAS DE CUENTA (Usan authDB) ---

		// REGISTRO: Creación de cuentas nuevas con SRP6
		api.POST("/accounts", handlers.CreateAccount(authDB))

		// LOGIN: Validación de credenciales para NextAuth
		api.POST("/login", handlers.LoginAccount(authDB))

		// UTILIDAD: Verificar si un email ya tiene cuenta vinculada
		api.GET("/accounts/check/:email", handlers.CheckAccountByEmail(authDB))

		// --- RUTAS DE PERSONAJES (Usan charsDB) ---

		// OBTENER PERSONAJES: Lista real desde la tabla characters
		// Esta es la ruta que alimentará tu "Registro de Campaña" en el frontend
		api.GET("/accounts/characters/:id", handlers.GetUserCharacters(charsDB))

		// DASHBOARD: Podrías necesitar ambas DBs para estadísticas cruzadas
		api.GET("/accounts/dashboard/:id", handlers.GetDashboardSummary(authDB, charsDB))
	}

	// 7. Lanzar el servidor
	fmt.Println("🌐 API WoWpera escuchando en http://localhost:8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatalf("❌ No se pudo iniciar el servidor: %v", err)
	}
}
