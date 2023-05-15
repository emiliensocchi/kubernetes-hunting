# Distrofull container image infection

Infect any distrofull container image with a reverse-shell backdoor.


## Usage

### Identify the original CMD command used by the legitimate image

```shell
docker history <image-name>
```


### Complete the desired Dockerfile with the appropriate information

```shell
Base image to infect, listening IP, port number, original CMD command, etc.
```


### Build the Dockerfile into an infected image 

```shell
docker build -t <image_name:tag> .
```


### Test locally to make sure it works (instantiation is very application specific)

```shell
docker run --rm -p <host_port>:<container_port> <image_name:tag>
```
