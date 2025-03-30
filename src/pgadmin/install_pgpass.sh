#!/bin/sh
set -x

POSTGRES_DB=$(cat /run/secrets/postgres_db)
POSTGRES_USER=$(cat /run/secrets/postgres_user)
POSTGRES_PASSWORD=$(cat /run/secrets/postgres_password)

# Set password
mkdir -p /pgpass
PGADMIN_PASSWORD_FILE=/pgpass/pgpass
rm -rf $PGADMIN_PASSWORD_FILE;

cat >$PGADMIN_PASSWORD_FILE <<EOL 
*:*:*:${POSTGRES_USER}:${POSTGRES_PASSWORD}
EOL

# PG server file
PGADMIN_SERVER_JSON_FILE=/pgadmin4/servers.json ;
rm -rf $PGADMIN_SERVER_JSON_FILE ;

cat >$PGADMIN_SERVER_JSON_FILE <<EOL
{
    "Servers": {
        "1": {
            "Group": "Servers",
            "Name": "${NETWORK}",
            "Host": "postgres",
            "Port": 5432,
            "MaintenanceDB": "${POSTGRES_DB}",
            "Username": "${POSTGRES_USER}",
            "Favorite": true,
            "ConnectionParameters": {
                "sslmode": "prefer",
                "connect_timeout": 10,
                "passfile": "/pgpass/pgpass"
            }
        }
    }
}
EOL

# Set permissions
chmod 600 $PGADMIN_PASSWORD_FILE ;


