package models

import (
	"time"
	"github.com/uptrace/bun"
)

type Category struct {
	bun.BaseModel `bun:"table:category"`

	CategoryID int       `bun:"category_id,pk,autoincrement"`
	Name       string    `bun:"name,notnull"`
	LastUpdate time.Time `bun:"last_update,nullzero,default:current_timestamp"`
}

type FilmCategory struct {
	bun.BaseModel `bun:"table:film_category"`

	FilmID     int       `bun:"film_id,pk"`
	CategoryID int       `bun:"category_id,pk"`
	LastUpdate time.Time `bun:"last_update,nullzero,default:current_timestamp"`
}

type FilmActor struct {
	bun.BaseModel `bun:"table:film_actor"`

	ActorID    int       `bun:"actor_id,pk"`
	FilmID     int       `bun:"film_id,pk"`
	LastUpdate time.Time `bun:"last_update,nullzero,default:current_timestamp"`
}