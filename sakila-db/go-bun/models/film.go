package models

import (
	"time"

	"github.com/uptrace/bun"
)

type Film struct {
	bun.BaseModel `bun:"table:film"`

	FilmID             int       `bun:"film_id,pk,autoincrement"`
	Title              string    `bun:"title,notnull"`
	Description        *string   `bun:"description"`
	ReleaseYear        *int      `bun:"release_year"`
	LanguageID         int       `bun:"language_id,notnull"`
	OriginalLanguageID *int      `bun:"original_language_id"`
	RentalDuration     int       `bun:"rental_duration,notnull,default:3"`
	RentalRate         float64   `bun:"rental_rate,notnull,default:4.99"`
	Length             *int      `bun:"length"`
	ReplacementCost    float64   `bun:"replacement_cost,notnull,default:19.99"`
	Rating             *string   `bun:"rating,default:'G'"`
	SpecialFeatures    *string   `bun:"special_features"`
	LastUpdate         time.Time `bun:"last_update,nullzero,default:current_timestamp"`

	// Relationships
	Language *Language `bun:"rel:belongs-to,join:language_id=language_id"`
}
