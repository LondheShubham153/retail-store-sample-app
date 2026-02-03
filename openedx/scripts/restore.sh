#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <backup_file>"
  exit 1
fi

BACKUP_FILE="$1"

case "$BACKUP_FILE" in
  *.sql)
    mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < "$BACKUP_FILE"
    ;;
  *.archive)
    mongorestore --uri="$MONGO_URI" --archive="$BACKUP_FILE" --drop
    ;;
  *.rdb)
    echo "Restore Redis RDB using your managed provider or redis-cli in a maintenance window."
    ;;
  *)
    echo "Unknown backup file type: $BACKUP_FILE"
    exit 1
    ;;
 esac
