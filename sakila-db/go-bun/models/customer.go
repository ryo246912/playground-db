package models

import (
	"time"
	"github.com/uptrace/bun"
)

type Customer struct {
	bun.BaseModel `bun:"table:customer"`

	CustomerID int        `bun:"customer_id,pk,autoincrement"`
	StoreID    int        `bun:"store_id,notnull"`
	FirstName  string     `bun:"first_name,notnull"`
	LastName   string     `bun:"last_name,notnull"`
	Email      *string    `bun:"email"`
	AddressID  int        `bun:"address_id,notnull"`
	Active     bool       `bun:"active,notnull,default:true"`
	CreateDate time.Time  `bun:"create_date,nullzero,default:current_timestamp"`
	LastUpdate *time.Time `bun:"last_update,nullzero,default:current_timestamp"`
}