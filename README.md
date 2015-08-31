DOCKER SENSU 
===========


```

docker build -t tomyhero/sensu .

docker run --name sensu -it -d -p 5672:5672 -p 11002:4567 -e GRAPHITE_HOST=$(docker inspect --format {{.NetworkSettings.IPAddress}} sensu-dashboard-graphite)  \
-e "MAIL_TO=alert@example.com" -e "DASHBOARD_URL=http://uchiwa.example.com/" \
tomyhero/sensu bash

```


