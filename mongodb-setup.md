# MongoDB Replica Set High Availability

Setting up 3 HA MongoDB containers 

## Step 1: Start MongoDB Containers

```bash
# Start the first MongoDB container as a primary node
docker run -d -p 27017:27017 --name mongo1 -v /opt/mongo1/data/db:/data/db --network mongoCluster mongo:7.0 mongod --replSet myReplicaSet --bind_ip_all

# Start the second MongoDB container as a secondary node
docker run -d -p 27018:27017 --name mongo2 -v /opt/mongo2/data/db:/data/db --network mongoCluster mongo:7.0 mongod --replSet myReplicaSet --bind_ip_all 

# Start the third MongoDB container as another secondary node
docker run -d -p 27019:27017 --name mongo3 -v /opt/mongo3/data/db:/data/db --network mongoCluster mongo:7.0 mongod --replSet myReplicaSet --bind_ip_all
```

## Step 2: Configure MongoDB Replica Set

### Initiate Replica Set configuration
```bash
docker exec -it mongo1 mongosh

rs.initiate(
  {
    _id: "myReplicaSet",
    members: [
      { _id: 0, host: "mongo1" },
      { _id: 1, host: "mongo2" },
      { _id: 2, host: "mongo3" }
    ]
  }
)
```
or simply
```bash
docker exec -it mongo1 mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"mongo1\"},
   {_id: 1, host: \"mongo2\"},
   {_id: 2, host: \"mongo3\"}
 ]
})"
```
## Step 3: Create 'internshipdb' and Enable Authentication


### Create 'internshipdb' and enable authentication

```bash
docker exec -it mongo1 mongosh --eval 'db.createUser({ user: "internshipAdmin", pwd: "admin", roles: [{ role: "readWrite", db: "internshipdb" }]})' internshipdb
```

### Use authenticated user
```bash
docker exec -it mongo1 mongosh --eval 'db.auth("internshipAdmin", "admin")' internshipdb
```

## Step 4: Create Collections and Insert Records

### Insert records into 'cities' collection
```bash
docker exec -it mongo1 mongosh --eval '
db.cities.insertMany([
  { name: "New York", population: 8623000, country: "USA" },
  { name: "Los Angeles", population: 3999759, country: "USA" },
  { name: "London", population: 8982000, country: "UK" },
  // Add more city documents as needed
]);' internshipdb
```
Add more as needed by

```bash
db.countries.insertMany()
```
### Insert records into 'countries' collection
```bash
docker exec -it mongo1 mongosh --eval 'db.countries.insertMany([{ name: "Switzerland", capital: "Bern", population: 8591361 },{ name: "Finland", capital: "Helsinki", population: 5540720 }])' internshipdb
```

Add more as needed by

```bash
db.countries.insertMany()
```

## Step 5 Connecting the database

### Insert mongo1, mongo2, mongo3 to /etc/hosts
```
127.0.0.1	localhost
<mongo1-container-IP>	mongo1
<mongo1-container-IP>	mongo2
<mongo1-container-IP>	mongo3
```

### Change /etc/mongod.conf.orig configuration

From
```
net:
  port: 27017
  bindIp: 127.0.0.1
```

to 

```
net:
  port: 27017
  bindIp: [$CONTAINER_PUBLIC_IP]
```
```bash
sed -i "s/^ *bindIp.*/bindIp: $CONTAINER_PUBLIC_IP/" /etc/mongod.conf.orig
```