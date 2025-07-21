package models

import (
	"time"
	"github.com/uptrace/bun"
)

type Actor struct {
	bun.BaseModel `bun:"table:actor"`

	ActorID    int       `bun:"actor_id,pk,autoincrement"`
	FirstName  string    `bun:"first_name,notnull"`
	LastName   string    `bun:"last_name,notnull"`
	LastUpdate time.Time `bun:"last_update,nullzero,default:current_timestamp"`
}