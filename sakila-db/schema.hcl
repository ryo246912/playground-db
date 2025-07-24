table "actor" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "actor_id" {
    null           = false
    type           = smallint
    unsigned       = true
    auto_increment = true
  }
  column "first_name" {
    null = false
    type = varchar(45)
  }
  column "last_name" {
    null = false
    type = varchar(45)
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.actor_id]
  }
  index "idx_actor_last_name" {
    columns = [column.last_name]
  }
}
table "address" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "address_id" {
    null           = false
    type           = smallint
    unsigned       = true
    auto_increment = true
  }
  column "address" {
    null = false
    type = varchar(50)
  }
  column "address2" {
    null = true
    type = varchar(50)
  }
  column "address3" {
    null = true
    type = varchar(50)
  }
  column "district" {
    null = false
    type = varchar(20)
  }
  column "city_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "postal_code" {
    null = true
    type = varchar(10)
  }
  column "phone" {
    null = false
    type = varchar(20)
  }
  column "location" {
    null = false
    type = geometry
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.address_id]
  }
  foreign_key "fk_address_city" {
    columns     = [column.city_id]
    ref_columns = [table.city.column.city_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_city_id" {
    columns = [column.city_id]
  }
  index "idx_location" {
    columns = [column.location]
    type    = SPATIAL
  }
}
table "category" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "category_id" {
    null           = false
    type           = tinyint
    unsigned       = true
    auto_increment = true
  }
  column "name" {
    null = false
    type = varchar(25)
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.category_id]
  }
}
table "city" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "city_id" {
    null           = false
    type           = smallint
    unsigned       = true
    auto_increment = true
  }
  column "city" {
    null = false
    type = varchar(50)
  }
  column "country_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.city_id]
  }
  foreign_key "fk_city_country" {
    columns     = [column.country_id]
    ref_columns = [table.country.column.country_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_country_id" {
    columns = [column.country_id]
  }
}
table "country" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "country_id" {
    null           = false
    type           = smallint
    unsigned       = true
    auto_increment = true
  }
  column "country" {
    null = false
    type = varchar(50)
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.country_id]
  }
}
table "customer" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "customer_id" {
    null           = false
    type           = smallint
    unsigned       = true
    auto_increment = true
  }
  column "store_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "first_name" {
    null = false
    type = varchar(45)
  }
  column "last_name" {
    null = false
    type = varchar(45)
  }
  column "email" {
    null = true
    type = varchar(50)
  }
  column "address_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "active" {
    null    = false
    type    = bool
    default = 1
  }
  column "create_date" {
    null = false
    type = datetime
  }
  column "last_update" {
    null      = true
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.customer_id]
  }
  foreign_key "fk_customer_address" {
    columns     = [column.address_id]
    ref_columns = [table.address.column.address_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_customer_store" {
    columns     = [column.store_id]
    ref_columns = [table.store.column.store_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_address_id" {
    columns = [column.address_id]
  }
  index "idx_fk_store_id" {
    columns = [column.store_id]
  }
  index "idx_last_name" {
    columns = [column.last_name]
  }
}
table "film" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "film_id" {
    null           = false
    type           = smallint
    unsigned       = true
    auto_increment = true
  }
  column "title" {
    null = false
    type = varchar(128)
  }
  column "description" {
    null = true
    type = text
  }
  column "release_year" {
    null = true
    type = year
  }
  column "language_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "original_language_id" {
    null     = true
    type     = tinyint
    unsigned = true
  }
  column "rental_duration" {
    null     = false
    type     = tinyint
    default  = 3
    unsigned = true
  }
  column "rental_rate" {
    null     = false
    type     = decimal(4,2)
    default  = 4.99
    unsigned = false
  }
  column "length" {
    null     = true
    type     = smallint
    unsigned = true
  }
  column "replacement_cost" {
    null     = false
    type     = decimal(5,2)
    default  = 19.99
    unsigned = false
  }
  column "rating" {
    null    = true
    type    = enum("G","PG","PG-13","R","NC-17")
    default = "G"
  }
  column "special_features" {
    null = true
    type = set("Trailers","Commentaries","Deleted Scenes","Behind the Scenes")
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.film_id]
  }
  foreign_key "fk_film_language" {
    columns     = [column.language_id]
    ref_columns = [table.language.column.language_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_film_language_original" {
    columns     = [column.original_language_id]
    ref_columns = [table.language.column.language_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_language_id" {
    columns = [column.language_id]
  }
  index "idx_fk_original_language_id" {
    columns = [column.original_language_id]
  }
  index "idx_title" {
    columns = [column.title]
  }
}
table "film_actor" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "actor_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "film_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.actor_id, column.film_id]
  }
  foreign_key "fk_film_actor_actor" {
    columns     = [column.actor_id]
    ref_columns = [table.actor.column.actor_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_film_actor_film" {
    columns     = [column.film_id]
    ref_columns = [table.film.column.film_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_film_id" {
    columns = [column.film_id]
  }
}
table "film_category" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "film_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "category_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.film_id, column.category_id]
  }
  foreign_key "fk_film_category_category" {
    columns     = [column.category_id]
    ref_columns = [table.category.column.category_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_film_category_film" {
    columns     = [column.film_id]
    ref_columns = [table.film.column.film_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "fk_film_category_category" {
    columns = [column.category_id]
  }
}
table "film_text" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "film_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "title" {
    null = false
    type = varchar(255)
  }
  column "description" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.film_id]
  }
  index "idx_title_description" {
    columns = [column.title, column.description]
    type    = FULLTEXT
  }
}
table "inventory" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "inventory_id" {
    null           = false
    type           = mediumint
    unsigned       = true
    auto_increment = true
  }
  column "film_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "store_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.inventory_id]
  }
  foreign_key "fk_inventory_film" {
    columns     = [column.film_id]
    ref_columns = [table.film.column.film_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_inventory_store" {
    columns     = [column.store_id]
    ref_columns = [table.store.column.store_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_film_id" {
    columns = [column.film_id]
  }
  index "idx_store_id_film_id" {
    columns = [column.store_id, column.film_id]
  }
}
table "language" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "language_id" {
    null           = false
    type           = tinyint
    unsigned       = true
    auto_increment = true
  }
  column "name" {
    null = false
    type = char(20)
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.language_id]
  }
}
table "payment" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "payment_id" {
    null           = false
    type           = smallint
    unsigned       = true
    auto_increment = true
  }
  column "customer_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "staff_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "rental_id" {
    null = true
    type = int
  }
  column "amount" {
    null     = false
    type     = decimal(5,2)
    unsigned = false
  }
  column "payment_date" {
    null = false
    type = datetime
  }
  column "last_update" {
    null      = true
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.payment_id]
  }
  foreign_key "fk_payment_customer" {
    columns     = [column.customer_id]
    ref_columns = [table.customer.column.customer_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_payment_rental" {
    columns     = [column.rental_id]
    ref_columns = [table.rental.column.rental_id]
    on_update   = CASCADE
    on_delete   = SET_NULL
  }
  foreign_key "fk_payment_staff" {
    columns     = [column.staff_id]
    ref_columns = [table.staff.column.staff_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "fk_payment_rental" {
    columns = [column.rental_id]
  }
  index "idx_fk_customer_id" {
    columns = [column.customer_id]
  }
  index "idx_fk_staff_id" {
    columns = [column.staff_id]
  }
}
table "rental" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "rental_id" {
    null           = false
    type           = int
    auto_increment = true
  }
  column "rental_date" {
    null = false
    type = datetime
  }
  column "inventory_id" {
    null     = false
    type     = mediumint
    unsigned = true
  }
  column "customer_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "return_date" {
    null = true
    type = datetime
  }
  column "staff_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.rental_id]
  }
  foreign_key "fk_rental_customer" {
    columns     = [column.customer_id]
    ref_columns = [table.customer.column.customer_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_rental_inventory" {
    columns     = [column.inventory_id]
    ref_columns = [table.inventory.column.inventory_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_rental_staff" {
    columns     = [column.staff_id]
    ref_columns = [table.staff.column.staff_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_customer_id" {
    columns = [column.customer_id]
  }
  index "idx_fk_inventory_id" {
    columns = [column.inventory_id]
  }
  index "idx_fk_staff_id" {
    columns = [column.staff_id]
  }
  index "rental_date" {
    unique  = true
    columns = [column.rental_date, column.inventory_id, column.customer_id]
  }
}
table "staff" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "staff_id" {
    null           = false
    type           = tinyint
    unsigned       = true
    auto_increment = true
  }
  column "first_name" {
    null = false
    type = varchar(45)
  }
  column "last_name" {
    null = false
    type = varchar(45)
  }
  column "address_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "picture" {
    null = true
    type = blob
  }
  column "email" {
    null = true
    type = varchar(50)
  }
  column "store_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "active" {
    null    = false
    type    = bool
    default = 1
  }
  column "username" {
    null = false
    type = varchar(16)
  }
  column "password" {
    null    = true
    type    = varchar(40)
    collate = "utf8mb4_bin"
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.staff_id]
  }
  foreign_key "fk_staff_address" {
    columns     = [column.address_id]
    ref_columns = [table.address.column.address_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_staff_store" {
    columns     = [column.store_id]
    ref_columns = [table.store.column.store_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_address_id" {
    columns = [column.address_id]
  }
  index "idx_fk_store_id" {
    columns = [column.store_id]
  }
}
table "store" {
  schema  = schema.sakila
  collate = "utf8mb4_0900_ai_ci"
  column "store_id" {
    null           = false
    type           = tinyint
    unsigned       = true
    auto_increment = true
  }
  column "manager_staff_id" {
    null     = false
    type     = tinyint
    unsigned = true
  }
  column "address_id" {
    null     = false
    type     = smallint
    unsigned = true
  }
  column "last_update" {
    null      = false
    type      = timestamp
    default   = sql("CURRENT_TIMESTAMP")
    on_update = sql("CURRENT_TIMESTAMP")
  }
  primary_key {
    columns = [column.store_id]
  }
  foreign_key "fk_store_address" {
    columns     = [column.address_id]
    ref_columns = [table.address.column.address_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  foreign_key "fk_store_staff" {
    columns     = [column.manager_staff_id]
    ref_columns = [table.staff.column.staff_id]
    on_update   = CASCADE
    on_delete   = RESTRICT
  }
  index "idx_fk_address_id" {
    columns = [column.address_id]
  }
  index "idx_unique_manager" {
    unique  = true
    columns = [column.manager_staff_id]
  }
}
schema "sakila" {
  charset = "utf8mb4"
  collate = "utf8mb4_unicode_ci"
}
