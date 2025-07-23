package playground

import (
	"context"
	"fmt"
	"log"

	"bun-playground/models"

	"github.com/uptrace/bun"
)

type ActorFilmCount struct {
	ActorID   int    `bun:"actor_id"`
	FirstName string `bun:"first_name"`
	LastName  string `bun:"last_name"`
	FilmCount int    `bun:"film_count"`
}

type FilmWithCategory struct {
	FilmID       int     `bun:"film_id"`
	Title        string  `bun:"title"`
	CategoryName string  `bun:"category_name"`
	RentalRate   float64 `bun:"rental_rate"`
}

type CategoryStats struct {
	CategoryName  string  `bun:"name"`
	FilmCount     int     `bun:"film_count"`
	AvgRentalRate float64 `bun:"avg_rental_rate"`
}

func AdvancedQueryExamples(db *bun.DB) {
	fmt.Println("=== 高度なクエリの例 ===")

	ctx := context.Background()

	JoinExamples(db, ctx)
	AggregationExamples(db, ctx)
	SubqueryExamples(db, ctx)
	TransactionExamples(db, ctx)
}

func JoinExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- JOIN クエリ ---")

	var actorFilmCounts []ActorFilmCount
	err := db.NewSelect().
		Model((*models.Actor)(nil)).
		Column("actor.actor_id", "actor.first_name", "actor.last_name").
		ColumnExpr("COUNT(film_actor.film_id) AS film_count").
		Join("LEFT JOIN film_actor ON film_actor.actor_id = actor.actor_id").
		Group("actor.actor_id", "actor.first_name", "actor.last_name").
		Order("film_count DESC").
		Limit(5).
		Scan(ctx, &actorFilmCounts)

	if err != nil {
		log.Printf("Actor-Film JOIN エラー: %v", err)
		return
	}

	fmt.Println("出演映画数が多いActor TOP 5:")
	for _, afc := range actorFilmCounts {
		fmt.Printf("%s %s: %d本の映画に出演\n", afc.FirstName, afc.LastName, afc.FilmCount)
	}

	var filmsWithCategory []FilmWithCategory
	err = db.NewSelect().
		Model((*models.Film)(nil)).
		Column("film.film_id", "film.title", "film.rental_rate").
		ColumnExpr("category.name AS category_name").
		Join("JOIN film_category ON film_category.film_id = film.film_id").
		Join("JOIN category ON category.category_id = film_category.category_id").
		Where("category.name = ?", "Action").
		Order("film.rental_rate DESC").
		Limit(3).
		Scan(ctx, &filmsWithCategory)

	if err != nil {
		log.Printf("Film-Category JOIN エラー: %v", err)
		return
	}

	fmt.Println("\nアクション映画（レンタル料金順）:")
	for _, fwc := range filmsWithCategory {
		fmt.Printf("%s (%s): $%.2f\n", fwc.Title, fwc.CategoryName, fwc.RentalRate)
	}
}

func AggregationExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- 集計クエリ ---")

	var categoryStats []CategoryStats
	err := db.NewSelect().
		Model((*models.Category)(nil)).
		Column("category.name").
		ColumnExpr("COUNT(film_category.film_id) AS film_count").
		ColumnExpr("AVG(film.rental_rate) AS avg_rental_rate").
		Join("LEFT JOIN film_category ON film_category.category_id = category.category_id").
		Join("LEFT JOIN film ON film.film_id = film_category.film_id").
		Group("category.category_id", "category.name").
		Having("COUNT(film_category.film_id) > 0").
		Order("film_count DESC").
		Limit(5).
		Scan(ctx, &categoryStats)

	if err != nil {
		log.Printf("カテゴリ統計エラー: %v", err)
		return
	}

	fmt.Println("カテゴリ別映画統計 TOP 5:")
	for _, cs := range categoryStats {
		fmt.Printf("%s: %d本, 平均レンタル料金 $%.2f\n", cs.CategoryName, cs.FilmCount, cs.AvgRentalRate)
	}

	type FilmLengthStats struct {
		MinLength  int     `bun:"min_length"`
		MaxLength  int     `bun:"max_length"`
		AvgLength  float64 `bun:"avg_length"`
		TotalFilms int     `bun:"total_films"`
	}

	var lengthStats FilmLengthStats
	err = db.NewSelect().
		Model((*models.Film)(nil)).
		ColumnExpr("MIN(length) AS min_length").
		ColumnExpr("MAX(length) AS max_length").
		ColumnExpr("AVG(length) AS avg_length").
		ColumnExpr("COUNT(*) AS total_films").
		Where("length IS NOT NULL").
		Scan(ctx, &lengthStats)

	if err != nil {
		log.Printf("映画長さ統計エラー: %v", err)
		return
	}

	fmt.Printf("\n映画の長さ統計:\n")
	fmt.Printf("最短: %d分, 最長: %d分, 平均: %.1f分, 総本数: %d本\n",
		lengthStats.MinLength, lengthStats.MaxLength, lengthStats.AvgLength, lengthStats.TotalFilms)
}

func SubqueryExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- サブクエリ ---")

	var expensiveFilms []models.Film
	avgRentalRateSubquery := db.NewSelect().
		Model((*models.Film)(nil)).
		ColumnExpr("AVG(rental_rate)")

	err := db.NewSelect().
		Model(&expensiveFilms).
		Column("title", "rental_rate").
		Where("rental_rate > (?)", avgRentalRateSubquery).
		Order("rental_rate DESC").
		Limit(3).
		Scan(ctx)

	if err != nil {
		log.Printf("平均以上料金映画検索エラー: %v", err)
		return
	}

	fmt.Println("平均レンタル料金以上の映画 TOP 3:")
	for _, film := range expensiveFilms {
		fmt.Printf("%s: $%.2f\n", film.Title, film.RentalRate)
	}

	type PopularActor struct {
		FirstName string `bun:"first_name"`
		LastName  string `bun:"last_name"`
		FilmCount int    `bun:"film_count"`
	}

	var popularActors []PopularActor
	maxFilmsSubquery := db.NewSelect().
		Model((*models.Actor)(nil)).
		ColumnExpr("MAX(film_count)").
		TableExpr("(?) AS actor_film_counts",
			db.NewSelect().
				Model((*models.Actor)(nil)).
				Column("actor.actor_id").
				ColumnExpr("COUNT(film_actor.film_id) AS film_count").
				Join("LEFT JOIN film_actor ON film_actor.actor_id = actor.actor_id").
				Group("actor.actor_id"))

	err = db.NewSelect().
		TableExpr("(?) AS afc",
			db.NewSelect().
				Model((*models.Actor)(nil)).
				Column("actor.first_name", "actor.last_name").
				ColumnExpr("COUNT(film_actor.film_id) AS film_count").
				Join("LEFT JOIN film_actor ON film_actor.actor_id = actor.actor_id").
				Group("actor.actor_id", "actor.first_name", "actor.last_name")).
		Column("afc.first_name", "afc.last_name", "afc.film_count").
		Where("afc.film_count = (?)", maxFilmsSubquery).
		Scan(ctx, &popularActors)

	if err != nil {
		log.Printf("最多出演Actor検索エラー: %v", err)
		return
	}

	fmt.Println("\n最も多くの映画に出演しているActor:")
	for _, actor := range popularActors {
		fmt.Printf("%s %s: %d本\n", actor.FirstName, actor.LastName, actor.FilmCount)
	}
}

func TransactionExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("=== トランザクションの例 ===")

	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		log.Printf("トランザクション開始エラー: %v", err)
		return
	}

	defer func() {
		if err != nil {
			log.Printf("トランザクションエラー: %v", err)
			rollbackErr := tx.Rollback()
			if rollbackErr != nil {
				log.Printf("トランザクションロールバック失敗: %v", rollbackErr)
			} else {
				log.Println("トランザクションがロールバックされました")
			}
		} else {
			commitErr := tx.Commit()
			if commitErr != nil {
				log.Printf("トランザクションコミット失敗: %v", commitErr)
				// コミット失敗は元のエラーがない場合でも、この関数のエラーとすべき
				err = commitErr // ここで名前付き戻り値の err に代入
				log.Println("トランザクションのコミットに失敗しました")
			} else {
				log.Println("トランザクションが正常にコミットされました")
			}
		}
	}()

	_, err = db.NewInsert().Model(&models.Actor{
		FirstName: "山田2",
		LastName:  "太郎2",
	}).Exec(ctx)
	if err != nil {
		log.Printf("Actor作成エラー: %v", err)
		return
	}

	_, err = db.NewInsert().Model(&models.Actor{
		ActorID:   223,
		FirstName: "鈴木2",
		LastName:  "花子2",
	}).Exec(ctx)
	if err != nil {
		log.Printf("Actor作成エラー: %v", err)
		return
	}
	fmt.Println("新しいActorを作成しました")
}
