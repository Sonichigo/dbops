package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/cockroachdb/cockroach-go/v2/crdb"
	_ "github.com/lib/pq"
)

const (
	cockroachDBConnString = "postgresql://root@crdb-cockroachdb-1:26257/pssql?sslmode=disable"
	postgreSQLConnString  = "postgresql://animesh:1Dz3tOO_cfArE1BwC8hXdg@tan-phoenix-6370.8nk.cockroachlabs.cloud:26257/pssql?sslmode=verify-full"
)

type Item struct {
	ID          int
	Name        string
	Description string
}

func main() {
	http.HandleFunc("/cockroachdb/create", createItemCockroachDB)
	http.HandleFunc("/cockroachdb/read", readItemsCockroachDB)
	http.HandleFunc("/postgresql/create", createItemPostgreSQL)
	http.HandleFunc("/postgresql/read", readItemsPostgreSQL)

	fmt.Println("Server is running on :8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func createItemCockroachDB(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("postgres", cockroachDBConnString)
	fmt.Println(cockroachDBConnString)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	item := Item{
		Name:        "Item 1",
		Description: "Description of Item 1",
	}

	err = crdb.ExecuteTx(r.Context(), db, nil, func(tx *sql.Tx) error {
		_, err := tx.Exec("INSERT INTO items (name, description) VALUES ($1, $2)", item.Name, item.Description)
		return err
	})

	if err != nil {
		log.Fatal(err)
	}

	w.Write([]byte("Item created in CockroachDB"))
}

func readItemsCockroachDB(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("postgres", cockroachDBConnString)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	rows, err := db.Query("SELECT id, name, description FROM items")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var items []Item
	for rows.Next() {
		var item Item
		err := rows.Scan(&item.ID, &item.Name, &item.Description)
		if err != nil {
			log.Fatal(err)
		}
		items = append(items, item)
	}

	for _, item := range items {
		fmt.Fprintf(w, "ID: %d, Name: %s, Description: %s\n", item.ID, item.Name, item.Description)
	}
}

func createItemPostgreSQL(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("postgres", postgreSQLConnString)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	item := Item{
		Name:        "Item 2",
		Description: "Description of Item 2",
	}

	_, err = db.Exec("INSERT INTO items (name, description) VALUES ($1, $2)", item.Name, item.Description)
	if err != nil {
		log.Fatal(err)
	}

	w.Write([]byte("Item created in PostgreSQL"))
}

func readItemsPostgreSQL(w http.ResponseWriter, r *http.Request) {
	db, err := sql.Open("postgres", postgreSQLConnString)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	rows, err := db.Query("SELECT id, name, description FROM items")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var items []Item
	for rows.Next() {
		var item Item
		err := rows.Scan(&item.ID, &item.Name, &item.Description)
		if err != nil {
			log.Fatal(err)
		}
		items = append(items, item)
	}

	for _, item := range items {
		fmt.Fprintf(w, "ID: %d, Name: %s, Description: %s\n", item.ID, item.Name, item.Description)
	}
}
