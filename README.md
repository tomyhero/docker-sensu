DOCKER SENSU 
===========


```

docker build -t tomyhero:sensu .

docker run --name sensu -it -d -p 5672:5672 -p 11002:4567 tomyhero:sensu bash

```


