Apache Guacamole 1.6.0 – Docker Deployment Guide
(With Automatic Domain and Let's Encrypt)

Overview
This setup provides a production-ready deployment of Apache Guacamole using Docker Compose, featuring:

Apache Guacamole 1.6.0 (latest release) – Web-based remote desktop gateway.

guacd 1.6.0 – The Guacamole proxy daemon.

PostgreSQL 15.2 (Alpine) – Persistent storage for users and connections.

Nginx – Reverse proxy with HTTPS support.

Certbot – Automated SSL/TLS certificate issuance and renewal via Let’s Encrypt.

Once deployed, the Guacamole web interface is available securely over HTTPS.

Deployment Steps
Extract the archive and navigate to the project directory:

tar -xzf guacamole-docker-setup-1.6.0.tar.gz

cd guacamole-docker-setup-1.6.0

Configure environment variables:
Edit the .env file to define:
Your domain name (e.g., remote.example.com)
Admin email for Let's Encrypt notifications
PostgreSQL database user, password, and name

Example:

nano .env

Build and start the containers:

./setup-and-run.sh

Access Guacamole via your browser:

https://your-domain

Default login credentials:

Username: guacadmin

Password: guacadmin

(Be sure to change the default password immediately after logging in.)

Maintenance and Backup

Manual PostgreSQL Backup to S3

Run the provided script to dump the Guacamole database and upload it to your S3-compatible storage (e.g., AWS or MinIO):

./backup-postgres-s3.sh

Update Images and Restart Services

To pull the latest Docker images and restart Guacamole:

./update-guacamole.sh

Additional Notes

SSL Certificates are automatically renewed by Certbot every 12 hours.
Nginx Configuration handles both API calls and WebSocket connections (/guacamole/ and /guacamole/websocket-tunnel).
The system uses PostgreSQL for all authentication and configuration, allowing easy migration and backups.
