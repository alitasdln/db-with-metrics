#!/bin/bash

docker exec  mongo1 mongosh --eval "rs.initiate({_id: \"myReplicaSet\",members: [{_id: 0, host: \"mongo1\"},{_id: 1, host: \"mongo2\"},{_id: 2, host: \"mongo3\"}]})"
docker exec  mongo1 mongosh --eval 'db.createUser({ user: "internshipAdmin", pwd: "admin", roles: [{ role: "readWrite", db: "internshipdb" }]})' internshipdb
docker exec  mongo1 mongosh --eval 'db.auth("internshipAdmin", "admin")' internshipdb
docker exec  mongo1 mongosh --eval '
db.cities.insertMany([
  { name: "New York", population: 8623000, country: "USA" },
  { name: "Los Angeles", population: 3999759, country: "USA" },
  { name: "London", population: 8982000, country: "UK" },
  { name: "Paris", population: 2206488, country: "France" },
  { name: "Tokyo", population: 9273000, country: "Japan" },
  { name: "Sydney", population: 5312163, country: "Australia" },
  { name: "Toronto", population: 2930000, country: "Canada" },
  { name: "Berlin", population: 3769495, country: "Germany" },
  { name: "Shanghai", population: 24256800, country: "China" },
  { name: "Mumbai", population: 18410000, country: "India" }
]);' internshipdb

docker exec -it mongo1 mongosh --eval 'db.countries.insertMany([
  { name: "Switzerland", capital: "Bern", population: 8591361 },
  { name: "Finland", capital: "Helsinki", population: 5540720 },
  { name: "Norway", capital: "Oslo", population: 5421241 },
  { name: "Sweden", capital: "Stockholm", population: 10379295 },
  { name: "Denmark", capital: "Copenhagen", population: 5822763 },
  { name: "Netherlands", capital: "Amsterdam", population: 17423234 },
  { name: "Belgium", capital: "Brussels", population: 11524454 },
  { name: "Germany", capital: "Berlin", population: 83122889 },
  { name: "Austria", capital: "Vienna", population: 9006398 },
  { name: "Italy", capital: "Rome", population: 60483973 }
]);' internshipdb
