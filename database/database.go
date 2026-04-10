package database

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

// Connect inicializa la conexión con una base de datos específica según la clave del env
func Connect(dbNameEnvKey string) (*gorm.DB, error) {
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASS") // Cambiado de DB_PASSWORD a DB_PASS para que coincida con .env
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv(dbNameEnvKey)

	// Si falta el nombre de la bd, usamos valores por defecto para evitar panics en pruebas rápidas
	if dbName == "" {
		if dbNameEnvKey == "DB_NAME_AUTH" {
			dbName = os.Getenv("DB_NAME") // Usa DB_NAME del .env para auth
			if dbName == "" {
				dbName = "acore_auth"
			}
		} else if dbNameEnvKey == "DB_NAME_CHARS" {
			dbName = "acore_characters"
		}
	}

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		dbUser, dbPassword, dbHost, dbPort, dbName)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Printf("❌ Error conectando a la base de datos %s: %v", dbName, err)
		return nil, err
	}

	log.Printf("✅ Conexión establecida a la base de datos %s", dbName)
	return db, nil
}
