#!/bin/bash

echo "===================================="
echo "🚀 Docker Hands-On Challenges Script"
echo "===================================="
echo ""

# Check Docker installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first!"
    exit 1
fi

# Challenge 1: Help for Docker commands
echo "✅ Challenge 1: Docker help commands"
docker container --help | head -n 10
docker run --help | head -n 10
read -p "Press Enter to continue..."

# Challenge 2: Search for mariadb
echo "✅ Challenge 2: Search for mariadb on Docker Hub"
docker search mariadb | head -n 10
read -p "Press Enter to continue..."

# Challenge 3: Pull alpine:edge and list images
echo "✅ Challenge 3: Pulling alpine:edge image"
docker pull alpine:edge
echo "✅ Listing images"
docker images | grep alpine
read -p "Press Enter to continue..."

# Challenge 4: Run alpine container and create file
echo "✅ Challenge 4: Running alpine container and creating file"
docker run -dit --name myalpine alpine:edge sh
docker exec -it myalpine sh -c "touch /root/a.txt"
docker ps
docker exec -it myalpine sh -c "ls -l /root/"
read -p "Press Enter to continue..."

# Challenge 5: Run Nginx
echo "✅ Challenge 5: Running Nginx web server"
docker run -d --name mynginx -p 80:80 nginx
echo "Visit http://localhost (or your server IP) to see Nginx"
docker logs mynginx | head -n 5
read -p "Press Enter to continue..."

# Challenge 6: Multiple Nginx & Apache containers
echo "✅ Challenge 6: Running multiple Nginx & Apache containers"
docker run -d -P nginx
docker run -d -P nginx
docker run -d -P httpd
docker run -d -P httpd
docker ps
echo "Stopping and removing all containers..."
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
read -p "Press Enter to continue..."

# Challenge 7: Ubuntu with SSH
echo "✅ Challenge 7: Ubuntu container with SSH"
docker run -dit --name myubuntu ubuntu:latest bash
docker exec -it myubuntu bash -c "apt update && apt install -y openssh-server && useradd -m testuser && echo 'testuser:password' | chpasswd && service ssh start"
UBUNTU_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myubuntu)
echo "SSH server started inside container. Use:"
echo "ssh testuser@$UBUNTU_IP (password: password)"
read -p "Press Enter to continue..."

# Challenge 8: Commit & Push custom image
echo "✅ Challenge 8: Commit container and create custom image"
docker commit myubuntu myubuntu:custom
docker images | grep myubuntu
echo "To push this image to Docker Hub, run:"
echo "docker login && docker tag myubuntu:custom <your_dockerhub_username>/myubuntu:custom && docker push <your_dockerhub_username>/myubuntu:custom"
read -p "Press Enter to continue..."

# Challenge 9: Build Apache from Dockerfile
echo "✅ Challenge 9: Building Apache custom image"
if [ ! -d "httpd" ]; then
    git clone https://github.com/docker-library/httpd.git
fi
cd httpd/2.4 || exit
chmod +x httpd-foreground
docker build -t myapache:custom .
docker run -d --name myapache -p 8080:80 myapache:custom
echo "Visit http://localhost:8080 to see Apache default page"
cd ../../
read -p "Press Enter to continue..."

# Challenge 10: Volumes with Apache
echo "✅ Challenge 10: Docker volumes with Apache"
docker volume create webapp1
docker run --rm -v webapp1:/data busybox sh -c 'echo "<h1>Hello from Docker Volume!</h1>" > /data/index.html'
docker run -d --name webapp1_httpd -p 8081:80 -v webapp1:/usr/local/apache2/htdocs httpd
echo "Visit http://localhost:8081 to see 'Hello from Docker Volume!'"
docker volume inspect webapp1
read -p "Press Enter to finish..."

echo "🎉 All Docker challenges completed!"
echo "You ran images, SSH into containers, built custom images, and used volumes!"
