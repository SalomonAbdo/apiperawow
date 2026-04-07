package models

import "time"

type Account struct {
	ID        uint      `gorm:"column:id;primaryKey;autoIncrement"`
	Username  string    `gorm:"column:username;uniqueIndex;not null;size:32"`
	Salt      []byte    `gorm:"column:salt;type:binary(32);not null"`
	Verifier  []byte    `gorm:"column:verifier;type:binary(32);not null"`
	Email     string    `gorm:"column:email;not null;default:''"`
	RegMail   string    `gorm:"column:reg_mail;not null;default:''"`
	Expansion uint8     `gorm:"column:expansion;not null;default:2"` // 2 = WotLK
	JoinDate  time.Time `gorm:"column:joindate;autoCreateTime"`
}

func (Account) TableName() string { return "account" }
