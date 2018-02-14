#!/bin/bash
APP_FE_HOST=${APP_FE_HOST:-"localhost"}
APP_FE_PORT=${APP_FE_PORT:-"30001"}
DB_HOST=${DB_HOST:-"localhost"}
DB_USER=${DB_USER:-"admin"}
DB_PASS=${DB_PASS:-"password"}

mysql -h $DB_HOST -u $DB_USER -p${DB_PASS} < create-tables.sql
mysql -h $DB_HOST -u $DB_USER -p${DB_PASS} < insert-data.sql

while true
do
    # Make requests to the mobile app
    locust --host http://${APP_FE_HOST}:${APP_FE_PORT} \
           -f ./locustfile.py \
           --clients 5 \
           --hatch-rate 5 \
           --num-request 100 \
           --no-web

    # Make requests to the db
    if [ "${STOP_MYSQL}" = "yes" ] ; then
        echo "Stopping mysql traffic from this node."
    else
        mysql -h $DB_HOST -u $DB_USER -p${DB_PASS} < get-data.sql
    fi

    sleep 0.5
done

