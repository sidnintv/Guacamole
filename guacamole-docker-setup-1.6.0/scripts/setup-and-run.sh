#!/bin/bash
set -euo pipefail

source .env

echo "0. Generating Nginx configuration from template"
sed "s/{{DOMAIN}}/$DOMAIN/g" ../nginx/conf.d/guacamole.conf.template > ../nginx/conf.d/guacamole.conf

echo "1. Generating Let's Encrypt certificate for $DOMAIN"
docker run --rm \
  -v "$(pwd)/../nginx/certs:/etc/letsencrypt" \
  -p 80:80 \
  certbot/certbot renew --quiet || \
  certbot/certbot certonly --standalone --non-interactive --agree-tos --no-eff-email \
  -m "$ADMIN_EMAIL" -d "$DOMAIN"

echo "2. Initializing Guacamole database"
docker run --rm guacamole/guacamole:1.6.0 \
  /opt/guacamole/bin/initdb.sh --postgresql > ../initdb/initdb.sql

echo "3. Starting all services"
docker compose up -d

echo "4. Checking container status:"
docker compose ps

echo "Done! Available at https://$DOMAIN (login/password: guacadmin/guacadmin)"