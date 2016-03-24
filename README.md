DOCKER SENSU 
===========

REQUIREMENT
---

* https://github.com/tomyhero/docker-sensu-dashboard-graphite


SETAUP
---

```

git clone https://github.com/tomyhero/docker-sensu.git
cd docker-sensu
docker build -t tomyhero/sensu .

docker run --name sensu -it -d \
	-p 5672:5672 \
	-p 11002:4567 \
	-e GRAPHITE_HOST=$(docker inspect --format {{.NetworkSettings.IPAddress}} sensu-dashboard-graphite)  \
	-e "MAIL_TO=alert@example.com" -e "DASHBOARD_URL=http://uchiwa.example.com/" \
	tomyhero/sensu bash

```

ENV
----


* RABITMQ_USER_NAME

default is sensu.

* RABITMQ_USER_PASSWORD

default is secret.

* GRAPHITE_HOST

default is localhost.

* GRAPHITE_PORT

default is 2003

* DASHBOARD_URL

default it http://localhost


* ON_SENSU_HANDLER_NOTIFICATION_MAILER

derfault is true 

* MAIL_FROM=${MAIL_FROM:-sensu@example.com}

default is -sensu@example.com

* MAIL_TO

default is alert@example.com

* SMTP_ADDRESS


default is localhost

* SMTP_PORT

default is 25

* SMTP_DOMAIN

default is localhost

* START_SMTP

default is -true

* ON_SENSU_HANDLER_NOTIFICATION_SLACK

default is false

* SLACK_WEBHOOK_URL

default is http://localhost

* START_SENSU_CLIENT

default is true

