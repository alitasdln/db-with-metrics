### Step 1: Run Prometheus Container

```bash
docker run -d -p 9090:9090 --name prometheus -v /opt/prometheus/:/etc/prometheus prom/prometheus
```

### Step 2: Run Node Exporter
```bash
docker run -d --name node-exporter --network="host" quay.io/prometheus/node-exporter
```
Ensure it's running and accessible. Node Exporter provides host-level metrics like CPU, memory, disk, etc.

### Step 3: Run cAdvisor
```bash
docker run -d --name=cadvisor --network="host" --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro google/cadvisor:latest
```
cAdvisor collects container-level metrics.

### Step 4: Configure Prometheus

Adjust the Prometheus configuration to scrape metrics from Node Exporter and cAdvisor. Edit /path/to/prometheus/config/prometheus.yml:

```bash
docker network inspect bridge -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}'
```

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100'] # node-exporter IP:port

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['localhost:8080'] # cadvisor IP:port
```

## Restart Prometheus for changes to take effect
```bash
docker stop prometheus 
docker start prometheus 
```
### Step 5: Launch Grafana Container

```bash
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

### Step 3: Connect Grafana to Prometheus

    Open your browser and navigate to http://localhost:3000.
    Log in to Grafana using the default credentials (username: admin, password: admin).
    Go to Configuration > Data Sources.
    Click Add data source.
    Choose Prometheus as the type.
    In the URL field, enter the IP address and port of your Prometheus instance (e.g., http://172.17.0.1:9090).
    Click Save & Test to verify the connection.
