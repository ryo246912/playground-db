package models

import (
	"time"

	"github.com/uptrace/bun"
)

type Language struct {
	bun.BaseModel `bun:"table:language"`

	LanguageID uint8     `bun:"language_id,pk,autoincrement"` // language_id
	Name       string    `bun:"name"`                         // name
	LastUpdate time.Time `bun:"last_update"`                  // last_update
}
