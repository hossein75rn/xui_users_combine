#!/bin/bash

# Update package lists
sudo apt update

# Install software-properties-common if not present
sudo apt install -y software-properties-common

# Add the ondrej/php PPA
sudo add-apt-repository -y ppa:ondrej/php

# Update package lists again after adding the PPA
sudo apt update

# Install nginx
sudo apt install -y nginx

# Allow necessary firewall ports
sudo ufw allow 'Nginx Full'
sudo ufw allow 2107/tcp   # API
sudo ufw allow 8080/tcp   # index.html site

# Install PHP 8.1 and PHP-FPM along with necessary extensions
sudo apt install -y php8.1-fpm php8.1-curl php8.1-sqlite3

# Create necessary directories
mkdir -p "/var/www/api/v2"
mkdir -p "/var/www/html"

sudo chown www-data:www-data /etc/x-ui/x-ui.db
sudo chmod 664 /etc/x-ui/x-ui.db

# 🔹 Nginx Configuration: API (Port 2107)
sudo bash -c 'cat > /etc/nginx/sites-available/api <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name _;

    root /var/www;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF'

# 🔹 Nginx Configuration: Serve `index.html` on Port 8080
sudo bash -c 'cat > /etc/nginx/sites-available/web <<EOF
server {
    listen 8080;
    listen [::]:8080;
    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF'

# Enable both sites
sudo ln -s /etc/nginx/sites-available/api /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/web /etc/nginx/sites-enabled/

# Define the repository URL
REPO_URL="https://v.anamin.ir/api/ganji/xui/v1/panels/"

# List of files to download (.hrn → rename to .php)
FILES=("index" "api" "countClients" "findClient" "insertClient")

# Download .hrn files and rename them to .php
for file in "${FILES[@]}"; do
    curl -sSL "${REPO_URL}/${file}.hrn" -o "/var/www/api/v2/${file}.php"
    
    if [ $? -eq 0 ]; then
        echo "✅ Downloaded and renamed ${file}.hrn to ${file}.php"
    else
        echo "❌ Error downloading ${file}.hrn from ${REPO_URL}"
        exit 1  # Exit if any download fails
    fi
done

# Download index.html and serve it on port 8080
curl -sSL https://v.anamin.ir/api/ganji/xui/v1/panels/index.html -o /var/www/html/index.html

# Set correct ownership & permissions
sudo chown -R www-data:www-data /var/www/api/v2 /var/www/html
sudo chmod 644 /var/www/api/v2/*.php /var/www/html/index.html

# Restart services
sudo systemctl restart php8.1-fpm
sudo systemctl reload nginx

echo "✅ Setup completed successfully."
