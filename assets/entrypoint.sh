#!/bin/bash

set -e

RABITMQ_USER_NAME=${RABITMQ_USER_NAME:-sensu}
RABITMQ_USER_PASSWORD=${RABITMQ_USER_PASSWORD:-secret}

GRAPHITE_HOST=${GRAPHITE_HOST:-localhost}
GRAPHITE_PORT=${GRAPHITE_PORT:-2003}

DASHBOARD_URL=${DASHBOARD_URL:-"http://localhost"}
MAIL_FROM=${MAIL_FROM:-sensu@example.com}
MAIL_TO=${MAIL_TO:-alert@example.com}
SMTP_ADDRESS=${SMTP_ADDRESS:-localhost}
SMTP_PORT=${SMTP_PORT:-25}
SMTP_DOMAIN=${SMTP_DOMAIN:-localhost}

START_SMTP=${START_SMTP:-true}
START_SENSU_CLIENT=${START_SENSU_CLIENT:-true}


# Running RabbitMQ
# ================
update-rc.d rabbitmq-server defaults
/etc/init.d/rabbitmq-server start

rabbitmqctl add_vhost /sensu
rabbitmqctl add_user $RABITMQ_USER_NAME $RABITMQ_USER_PASSWORD 
rabbitmqctl set_permissions -p /sensu $RABITMQ_USER_NAME ".*" ".*" ".*"


sed s/secret/$RABITMQ_USER_PASSWORD/g -i /etc/sensu/config.json

cp /app/assets/sensu/conf.d/* /etc/sensu/conf.d/
cp /app/assets/sensu/mutators/* /etc/sensu/mutators/
cp /app/assets/sensu/plugins/* /etc/sensu/plugins/

sed s/test/basic/g -i /etc/sensu/conf.d/client.json

sed s/{{GRAPHITE_HOST}}/$GRAPHITE_HOST/g -i /etc/sensu/conf.d/handler_graphite.json
sed s/{{GRAPHITE_PORT}}/$GRAPHITE_PORT/g -i /etc/sensu/conf.d/handler_graphite.json

sed s,{{DASHBOARD_URL}},$DASHBOARD_URL,g -i /etc/sensu/conf.d/mailer.json
sed s/{{MAIL_FROM}}/$MAIL_FROM/g -i /etc/sensu/conf.d/mailer.json
sed s/{{MAIL_TO}}/$MAIL_TO/g -i /etc/sensu/conf.d/mailer.json
sed s/{{SMTP_ADDRESS}}/$SMTP_ADDRESS/g -i /etc/sensu/conf.d/mailer.json
sed s/{{SMTP_PORT}}/$SMTP_PORT/g -i /etc/sensu/conf.d/mailer.json
sed s/{{SMTP_DOMAIN}}/$SMTP_DOMAIN/g -i /etc/sensu/conf.d/mailer.json

# Running Redis
# ================
update-rc.d redis-server defaults
/etc/init.d/redis-server start


# Running Sensu
# ================
 /etc/init.d/sensu-server start
 /etc/init.d/sensu-api start

# Enable Sensu on boot
#-----------------
update-rc.d sensu-server defaults
update-rc.d sensu-api defaults


# Running the Sensu client
#-----------------
if $START_SENSU_CLIENT == true ; then
/etc/init.d/sensu-client start
update-rc.d sensu-client defaults
fi 

if $START_SMTP == true ; then
/etc/init.d/sendmail start
update-rc.d sendmail defaults
fi


bash
