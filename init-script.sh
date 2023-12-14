#!/bin/bash

# Fetch the IP address from Docker network inspect
IP_ADDRESS=$(docker network inspect bridge -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}')

# Update Prometheus configuration with obtained IP addresses
sed -i "s/x.x.x.x/$IP_ADDRESS/g" prometheus.yml

# Start Docker Compose services
docker-compose up -d