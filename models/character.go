package models

import (
	"time"
)

type Character struct {
	// guid: Global Unique Identifier (Primary Key)
	Guid uint32 `gorm:"primaryKey;column:guid" json:"guid"`
	// account: Relación con la cuenta de auth
	Account uint32 `gorm:"column:account" json:"account_id"`
	Name    string `gorm:"column:name" json:"name"`
	Race    uint8  `gorm:"column:race" json:"race"`
	Class   uint8  `gorm:"column:class" json:"class"`
	Gender  uint8  `gorm:"column:gender" json:"gender"`
	Level   uint8  `gorm:"column:level" json:"level"`
	// online: 0 o 1
	Online uint8 `gorm:"column:online" json:"online"`
	// totaltime: Segundos totales de juego
	TotalTime uint32 `gorm:"column:totaltime" json:"total_time"`
	// zone: ID de la zona actual (smallint)
	Zone uint16 `gorm:"column:zone" json:"zone"`
	// money: Cobre total (int unsigned)
	Money uint32 `gorm:"column:money" json:"money"`
	// creation_date: timestamp
	CreatedAt time.Time `gorm:"column:creation_date" json:"created_at"`
}

// TableName indica a GORM que no busque "characters" en plural automático
func (Character) TableName() string {
	return "characters"
}
