#!/bin/bash
set -euo pipefail

source .env

BACKUP_FILE="guacamole-$(date +%F_%H-%M-%S).sql.gz"

echo "Creating PostgreSQL dump..."
docker exec guac-db pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip > "$BACKUP_FILE"

echo "Uploading to S3 ($S3_BUCKET)..."
AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  aws --endpoint-url "$S3_ENDPOINT" s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/"

rm "$BACKUP_FILE"
echo "Backup completed."
