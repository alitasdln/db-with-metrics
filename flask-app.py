from flask import Flask, jsonify
from pymongo import MongoClient
from bson.json_util import dumps

app = Flask(__name__)

#All nodes have to be for safe fa'lover and automatic recovery purposes
client = MongoClient('mongodb://mongo1:27017,mongo2:27017,mongo3:27017/?replicaSet=myReplicaSet')


@app.route('/')
def hello():
    return 'Hello Python!'

@app.route('/staj')
def get_random_city():
    db = client['internshipdb']  
    print(db)
    cities = db['cities']  
    random_city = cities.aggregate([{ '$sample': { 'size': 1 } }])

    # Convert the result to a list and exclude the '_id' field
    result = list(random_city)
    for city in result:
        city.pop('_id', None)

    # Return JSON using dumps from bson.json_util
    return dumps(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4444)  
