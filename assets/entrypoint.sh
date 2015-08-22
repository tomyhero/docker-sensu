#!/bin/bash

set -e

RABITMQ_USER_NAME=${RABITMQ_USER_NAME:-sensu}
RABITMQ_USER_PASSWORD=${RABITMQ_USER_PASSWORD:-secret}

# Running RabbitMQ
# ================
update-rc.d rabbitmq-server defaults
/etc/init.d/rabbitmq-server start

rabbitmqctl add_vhost /sensu
rabbitmqctl add_user $RABITMQ_USER_NAME $RABITMQ_USER_PASSWORD 
rabbitmqctl set_permissions -p /sensu $RABITMQ_USER_NAME ".*" ".*" ".*"


sed s/secret/$RABITMQ_USER_PASSWORD/g -i /etc/sensu/config.json

cp /app/assets/sensu/basic.json /etc/sensu/conf.d/basic.json

sed s/test/basic/g -i /etc/sensu/conf.d/client.json


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
 /etc/init.d/sensu-client start
update-rc.d sensu-client defaults


bash

