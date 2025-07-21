package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"bun-playground/playground"
	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/mysqldialect"
	"github.com/uptrace/bun/extra/bundebug"
)

func main() {
	fmt.Println("=== Bun ORM Playground ===")

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	username := os.Getenv("ROOTUSER")
	password := os.Getenv("ROOTPASS")
	database := os.Getenv("DATABASE")

	dsn := fmt.Sprintf("%s:%s@tcp(127.0.0.1:3306)/%s?parseTime=true&loc=UTC", username, password, database)

	sqldb, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal(err)
	}
	defer sqldb.Close()

	db := bun.NewDB(sqldb, mysqldialect.New())
	db.AddQueryHook(bundebug.NewQueryHook(bundebug.WithVerbose(true)))

	err = db.Ping()
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	fmt.Println("Successfully connected to MySQL database!")

	playground.CRUDExamples(db)

	playground.AdvancedQueryExamples(db)

	fmt.Println("\n=== Playground 完了 ===")
}
