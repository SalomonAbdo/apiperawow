package database

import (
	"fmt"
	"os"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func Connect() (*gorm.DB, error) {
	// Usamos los datos que proporcionaste
	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?parseTime=true&charset=utf8mb4&loc=UTC",
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASS"),
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"),
	)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, err
	}

	// --- BLOQUE DE PING ---
	// GORM usa un pool de conexiones, extraemos la instancia de sql.DB nativa
	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	// Configuramos un timeout corto para el ping
	sqlDB.SetConnMaxLifetime(time.Minute * 3)

	// El "Ping" real a la base de datos AzerothCore
	if err := sqlDB.Ping(); err != nil {
		return nil, fmt.Errorf("el servidor MySQL no responde: %w", err)
	}

	return db, nil
}
