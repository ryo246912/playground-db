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
}

func ReadExamples(db *bun.DB, ctx context.Context) {
	fmt.Println("\n--- READ 操作 ---")

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

	var count int
	count, err = db.NewSelect().Model((*models.Actor)(nil)).Count(ctx)
	if err != nil {
		log.Printf("カウントエラー: %v", err)
		return
	}
	fmt.Printf("Actor総数: %d人\n", count)

	var actor models.Actor
	err = db.NewSelect().Model(&actor).Where("first_name = ?", "PENELOPE").Limit(1).Scan(ctx)
	if err != nil {
		log.Printf("特定Actor検索エラー: %v", err)
		return
	}
	fmt.Printf("PENELOPE という名前のActor: %s %s\n", actor.FirstName, actor.LastName)
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
