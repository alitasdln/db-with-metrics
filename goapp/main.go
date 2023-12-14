package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"math/rand"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)


const uri = "mongodb://mongo1:27017,mongo2:27017,mongo3:27017/?replicaSet=myReplicaSet"


type Item struct {
	ID   string `json:"_id,omitempty"`
	Name string `json:"name"`
	Capital   string `json:"capital"`
	Population int    `json:"population"`
}

func getRandomItem(w http.ResponseWriter, r *http.Request) {

	client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(uri))
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer func() {
		if err = client.Disconnect(context.TODO()); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}()

	// Fetch a random item from your MongoDB collection
	collection := client.Database("internshipdb").Collection("countries")

	count, err := collection.CountDocuments(context.Background(), bson.D{})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	randomIndex := rand.Intn(int(count))
	cursor, err := collection.Find(context.Background(), bson.D{}, options.Find().SetSkip(int64(randomIndex)).SetLimit(1))
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer cursor.Close(context.Background())

	var item Item
	if cursor.Next(context.Background()) {
		if err := cursor.Decode(&item); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	// Return the fetched item as JSON
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(item)
}

func main() {
	http.HandleFunc("/staj", getRandomItem)
	fmt.Println("Server is running at :5555")
	http.ListenAndServe(":5555", nil)
}
