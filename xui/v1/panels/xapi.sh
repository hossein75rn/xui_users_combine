#!/bin/bash

# Check for root
if [[ "$EUID" -ne 0 ]]; then
  echo "❌ Please run as root (use sudo)"
  exit 1
fi

# Update package lists
sudo apt update

# Install essential tools
sudo apt install -y software-properties-common curl ufw

# Add the ondrej/php PPA
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

# Install nginx and PHP 8.1 + necessary extensions
sudo apt install -y nginx php8.1-fpm php8.1-curl php8.1-sqlite3

# Allow firewall ports
sudo ufw allow 7577/tcp
sudo ufw allow 'OpenSSH'
sudo ufw --force enable

# Create necessary directories
mkdir -p "/var/www/api/v2"
mkdir -p "/var/www/html"

# Optional: Set permissions for x-ui.db if needed
sudo chown www-data:www-data /etc/x-ui/x-ui.db 2>/dev/null || true
sudo chmod 664 /etc/x-ui/x-ui.db 2>/dev/null || true

# Unified NGINX Configuration: PHP API + Static site on port 7577
sudo bash -c 'cat > /etc/nginx/sites-available/app <<EOF
server {
    listen 7577;
    listen [::]:7577;
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

# Enable new NGINX site
sudo rm -f /etc/nginx/sites-enabled/api
sudo rm -f /etc/nginx/sites-enabled/web
sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/

# Define repo URL and file list
REPO_URL="https://v.anamin.ir/api/ganji/xui/v1/panels/"
FILES=("index" "api" "countClients" "findClient" "insertClient")

# Download PHP API files
for file in "${FILES[@]}"; do
    curl -sSL "${REPO_URL}/${file}.hrn" -o "/var/www/api/v2/${file}.php"
    
    if [ $? -eq 0 ]; then
        echo "✅ Downloaded and renamed ${file}.hrn to ${file}.php"
    else
        echo "❌ Error downloading ${file}.hrn from ${REPO_URL}"
        exit 1
    fi
done

# Download index.html
curl -sSL "${REPO_URL}/index.html" -o /var/www/html/index.html

# Set correct permissions
sudo chown -R www-data:www-data /var/www/api/v2 /var/www/html
sudo chmod 644 /var/www/api/v2/*.php /var/www/html/index.html

# Restart services
sudo systemctl restart php8.1-fpm
sudo nginx -t && sudo systemctl reload nginx

echo "✅ Setup completed successfully. Your site is now running on port 7577."
