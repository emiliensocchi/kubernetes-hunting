# Distroless container image infection

Infect any distroless container image with a reverse-shell backdoor.

*Note: this technique relies on extending the distroless image into an Alpine-based distrofull image, increasing the image's size by about 2.7 MB.*


## Usage

### Identify the original CMD command used by the legitimate image

```shell
docker history <image-name>
```


### Identify the path to the runtime environment used by the legitimate image (i.e. usually in its original ENTRYPOINT)

```shell
docker history <image-name>
```

```shell
docker inspect <image-name>
```


### Complete the desired Dockerfile with the appropriate information

```shell
Base image to infect, listening IP, port number, path to the application's runtime environment, original CMD command, etc.
```


### Build the Dockerfile into an infected image 

```shell
docker build -t <image_name:tag> .
```


### Test locally to make sure it works (instantiation is very application specific)

```shell
docker run --rm -p <host_port>:<container_port> <image_name:tag>
```


## Note

The `ENTRYPOINT` of a distroless image is usually set to the path of its application's runtime environment (e.g. `/nodejs/bin/node`), while the `CMD` is set to the actual binary of the application and sometimes command-line options (e.g. `my-app.js`)


## Original source for Alpine Linux 3.14.2

https://github.com/alpinelinux/docker-alpine/tree/6046c206b93945695d9c3efedcafe629a327fd85/x86_64
