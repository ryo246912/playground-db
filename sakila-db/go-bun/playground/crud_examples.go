package playground

import (
	"context"
	"fmt"
	"log"

	"bun-playground/models"

	"github.com/uptrace/bun"
)

func CRUDExamples(db *bun.DB) {

	ctx := context.Background()

	CreateExamples(db, ctx)
	ReadExamples(db, ctx)
	UpdateExamples(db, ctx)
	DeleteExamples(db, ctx)
}

func CreateExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- CREATE 操作 ---")

	// modelの構造体を使ってActorを作成
	newActor := &models.Actor{
		FirstName: "山田",
		LastName:  "太郎",
	}

	_, err := db.NewInsert().Model(newActor).Exec(ctx)
	if err != nil {
		log.Printf("Actor作成エラー: %v", err)
		return
	}
	fmt.Printf("新しいActorを作成しました: ID=%d, %s %s\n", newActor.ActorID, newActor.FirstName, newActor.LastName)

	// mapを使ってActorを作成
	_, err = db.NewInsert().Model(&map[string]interface{}{
		"first_name": "山田1",
		"last_name":  "太郎1",
	}).Table("actor").Exec(ctx)
	if err != nil {
		log.Printf("Actor作成エラー: %v", err)
		return
	}
	fmt.Println("新しいActorをmapで作成しました")

	// upsert(mysql)
	actor := &models.Actor{
		ActorID:   223,
		FirstName: "鈴木",
		LastName:  "花子",
	}
	_, err = db.NewInsert().
		Model(actor).
		On("DUPLICATE KEY UPDATE").
		Exec(ctx)
	if err != nil {
		log.Printf("Actorupsertエラー: %v", err)
		return
	}
}

func ReadExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- READ 操作 ---")

	// select文
	var actors []models.Actor
	err := db.NewSelect().Model(&actors).Limit(5).Scan(ctx)
	if err != nil {
		log.Printf("Actor取得エラー: %v", err)
		return
	}
	fmt.Printf("最初の5人のActor:\n")
	for _, actor := range actors {
		fmt.Printf("ID=%d, %s %s\n", actor.ActorID, actor.FirstName, actor.LastName)
	}

	// count文、Model((*models.Actor)(nil))でポインタ型を指定
	var count int
	count, err = db.NewSelect().Model((*models.Actor)(nil)).Count(ctx)
	if err != nil {
		log.Printf("カウントエラー: %v", err)
		return
	}
	fmt.Printf("Actor総数: %d人\n", count)

	// WHERE句
	var actor models.Actor
	err = db.NewSelect().Model(&actor).Where("first_name = ?", "PENELOPE").Limit(1).Scan(ctx)
	if err != nil {
		log.Printf("特定Actor検索エラー: %v", err)
		return
	}
	fmt.Printf("PENELOPE という名前のActor: %s %s\n", actor.FirstName, actor.LastName)

	// Scan(ctx, &var)でスキャン
	var customer1 models.Customer
	// (*models.Customer)(nil) のような形で渡す理由は、GoのORM（この場合はbun）で「モデルの型情報だけを渡したい」場合に使われるテクニックです。
	// 具体的には、bunの Model() メソッドは、構造体の型情報をもとにテーブル名やカラム情報を取得します。
	// &models.Customer{} のように値を渡すと、実際のデータを操作します。
	// (*models.Customer)(nil) のように nil ポインタを渡すことで、「Customer型の情報だけ」を bun に伝えます。これは、データの取得やカウントなど「型情報だけ必要」な場面（例：Count(ctx) や Scan(ctx, &map) など）でよく使われます。
	err = db.NewSelect().Model((*models.Customer)(nil)).Where("customer_id = ?", 1).Scan(ctx, &customer1)
	if err != nil {
		log.Printf("特定Customer検索エラー: %v", err)
		return
	}
	fmt.Printf("特定Customer: %d %s %s\n", customer1.CustomerID, customer1.FirstName, customer1.LastName)

	// Scan(ctx, &var)でmapにスキャン
	m := make(map[string]interface{})
	err = db.NewSelect().Model((*models.Customer)(nil)).Where("customer_id = ?", 1).Scan(ctx, &m)
	if err != nil {
		log.Printf("特定Customer検索エラー: %v", err)
		return
	}
	fmt.Printf("特定Customer: %v\n", m)
	fmt.Println(m["customer_id"])
	fmt.Println(m["first_name"])
	fmt.Println(m["last_name"])
	fmt.Println(m["email"])

	// Scan(ctx, &var)で変数にスキャン
	var name string
	err = db.NewSelect().Model((*models.Customer)(nil)).Where("customer_id = ?", 1).Column("first_name").Scan(ctx, &name)
	if err != nil {
		log.Printf("特定Customerの名前検索エラー: %v", err)
		return
	}
	fmt.Printf("特定Customerの名前: %s\n", name)

	// JOIN句
	var films []models.Film
	err = db.NewSelect().
		Model(&films).
		Column("film.title", "film.rental_rate").Relation("Language").Where("language.name = ?", "English").
		Limit(5).
		Scan(ctx)

	if err != nil {
		log.Printf("日本語映画検索エラー: %v", err)
		return
	}
	for _, film := range films {
		fmt.Printf("映画: %s, レンタル料金: $%.2f, 言語: %s\n", film.Title, film.RentalRate, film.Language.Name)
	}

	// JOIN句、relation先のクエリも一部のみ指定
	var films1 []models.Film
	err = db.NewSelect().
		Model(&films1).
		Column("film.title", "film.rental_rate").Relation("Language", func(q *bun.SelectQuery) *bun.SelectQuery {
		// ここでLanguageモデルから選択したいカラムを指定
		return q.Column("name") // 例えば、Languageテーブルの'name'カラムのみを選択
	}).Where("language.name = ?", "English").
		Limit(5).
		Scan(ctx)

	if err != nil {
		log.Printf("日本語映画検索エラー: %v", err)
		return
	}
	for _, film := range films1 {
		fmt.Printf("映画: %s, レンタル料金: $%.2f, 言語: %s\n", film.Title, film.RentalRate, film.Language.Name)
	}
}

func UpdateExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- UPDATE 操作 ---")

	var actor models.Actor
	err := db.NewSelect().Model(&actor).Where("first_name = ? AND last_name = ?", "山田", "太郎").Limit(1).Scan(ctx)
	if err != nil {
		log.Printf("更新対象Actor検索エラー: %v", err)
		return
	}

	actor.FirstName = "田中"
	_, err = db.NewUpdate().Model(&actor).Where("actor_id = ?", actor.ActorID).Exec(ctx)
	if err != nil {
		log.Printf("Actor更新エラー: %v", err)
		return
	}
	fmt.Printf("Actorを更新しました: %s %s\n", actor.FirstName, actor.LastName)
}

func DeleteExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- DELETE 操作 ---")

	var actor models.Actor
	err := db.NewSelect().Model(&actor).Where("first_name = ? AND last_name = ?", "田中", "太郎").Limit(1).Scan(ctx)
	if err != nil {
		log.Printf("削除対象Actor検索エラー: %v", err)
		return
	}

	_, err = db.NewDelete().Model(&actor).Where("actor_id = ?", actor.ActorID).Exec(ctx)
	if err != nil {
		log.Printf("Actor削除エラー: %v", err)
		return
	}
	fmt.Printf("Actorを削除しました: ID=%d\n", actor.ActorID)
}
