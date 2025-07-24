#!/bin/bash

echo "===================================="
echo "🧹 Docker Cleanup Script"
echo "===================================="

echo "Stopping all running containers..."
docker stop $(docker ps -q) 2>/dev/null

echo "Removing all containers..."
docker rm $(docker ps -aq) 2>/dev/null

echo "Removing dangling/unused images..."
docker image prune -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Removing unused networks..."
docker network prune -f

echo "✅ Docker environment cleaned up!"
docker system df
