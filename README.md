
### Installation and Usage
#### Setup

Clone this repository:

```bash
git clone https://github.com/alitasdln/db-with-metrics.git
```

Navigate to the project directory:
```bash
cd db-with-metrics
```

#### Starting the Environment

Start the environment with init script:

```bash
sudo ./init-script.sh >/dev/null 2>&1
```


#### Initializing MongoDB Replica Set and Database Population


After the environment is up and running, execute the initialization script:
```bash
sudo ./mongo-init.sh >/dev/null 2>&1
```
This script sets up the MongoDB replica set, creates a user for the database, and populates the database with sample city data.

Close everything with:
```bash
docker-compose down
```

#### Accessing Services

| Service       | URL                                                     | Credentials         |
|---------------|---------------------------------------------------------|---------------------|
| Traefik       | [http://localhost:8080](http://localhost:8080)           | -                   |
| Flask App     | [http://localhost:4444](http://localhost:4444)           | -                   |
| Random City   | [http://kartaca.localhost/pythonapp](http://kartaca.localhost/pythonapp) <br>  [http://localhost:4444/staj](http://localhost:4444/staj)| -         |
| Random Country   | [http://kartaca.localhost/goapp](http://kartaca.localhost/goapp) <br>  [http://localhost:4444/staj](http://localhost:5555/staj)| -         | 
| Prometheus    | [http://localhost:9090](http://localhost:9090)           | -                   |
| Grafana       | [http://kartaca.localhost/grafana](http://kartaca.localhost/grafana) | Username: admin <br> Password: admin |

To access ```Cadvisor``` and ```node-exporter``` dashboards, please, follow these steps:
- Add datasource: http://prometheus:9090
- Import respective dashboards: 
    - ```Node exporter (id:1860)``` 
    - ```Cadvisor exporter (id:14282)``` 

Services

Traefik: A reverse proxy for routing traffic to different services.
Flask App: A sample Flask application available at /pythonapp route.
MongoDB Replica Set: Three MongoDB instances forming a replica set for high availability.
Prometheus: For monitoring and metrics.
Grafana: A visualization tool, pre-configured with basic dashboards.

#### Directory Structure

    ./db: Contains directories for MongoDB volumes (mongo1, mongo2, mongo3) for persistent data.
    ./prometheus.yml: Configuration file for Prometheus.
    ./mongo_init.sh: Initialization script for MongoDB replica set and database population.
    ./Dockerfile: Dockerfile for building the Flask application.

## Project Progress

- [x] Environment Setup
- [x] Docker Compose Configuration
- [x] Initialization Script for MongoDB
- [x] Authentication for MongoDB
- [x] Python App Integration
- [x] Go App Integration
- [x] Prometheus Integration
- [x] Grafana Integration (Some minor issues)