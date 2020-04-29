# Docker development environment


Run this command to run the docker containers by running the docker-compose.yml
```sh
$ sudo docker-compose up
```

Run this command to get the list of the actif containers
```sh
$ sudo docker ps
```

Run this command to get the list of all the containers
```sh
$ sudo docker ps -a
```

Run this command to get the created images
```sh
$ sudo docker images
```

Run this command to remove an existing container
```sh
$ sudo docker container rm -f {IdOfTheContainer}
```

Run this command to remove an existing docker image
```sh
$ sudo docker rmi f {IdOfTheImage}
```

Run this command to get a bash shell in the container
```sh
$ sudo docker exec -it {IdOfTheContainer} /bin/bash
```


# Serve application


When docker is running, the application can be accessed like this 

Back-end (using php-symfony & mysql) launched on localhost:8080
Front-end (using compiled elm) launched on localhost:8001

