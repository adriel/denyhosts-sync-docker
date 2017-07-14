#!/bin/bash
set -eu
set -o pipefail

# Table to check if tables have been generated
TABLE='country_history'

printf "[database]
# Type of database. Choice of sqlite3, MySQLdb, psycopg2 (PostgreSQL)
type: mysql

db: ${MYSQL_DATABASE}
host: ${MYSQL_HOSTNAME}
user: ${MYSQL_USER}
passwd: ${MYSQL_PASSWORD}

# Maximum size of database connection pool. Default: 5
# For high volume servers, set this to 100 or so.
cp_max: 100" > /etc/denyhosts-server-database.conf

# Check if DB is running and accessable
until mysql -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --host="${MYSQL_HOSTNAME}" --port="${MYSQL_PORT}" -e "select 1" &>/dev/null; do
  >&2 echo "Database is unavailable - waiting"
  sleep 1
done
>&2 echo "Database is up - checking if tables exist"

# Check if tables exist, create if missing
if [[ $(mysql -N -s -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --host="${MYSQL_HOSTNAME}" --port="${MYSQL_PORT}" -e \
    "select count(*) from information_schema.tables where \
        table_schema='${MYSQL_DATABASE}' and table_name='${TABLE}';") -eq 1 ]]; then
    echo "Tables exists - starting server"
else
    echo 'Tables do not exist - creating tables'
    echo 'Y' | /usr/bin/denyhosts-server --recreate-database
fi

/usr/bin/denyhosts-server -c /etc/denyhosts-server.conf
