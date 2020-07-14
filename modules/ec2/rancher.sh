#! /bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher