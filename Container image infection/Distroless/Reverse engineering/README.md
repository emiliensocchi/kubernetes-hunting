# Reverse-engineer distroless images

Reverse-engineer any distroless container image by making it distrofull and interact with it with a shell.


## Usage

### Complete the Dockerfile with the appropriate information

```shell
Base image to make distrofull.
```


### Build the Dockerfile into a distrofull image

```shell
docker build -t <image_name:tag> .
```


### Instantiate the distrofull image and start an interactive shell

```shell
docker run -it --rm <image_name:tag> /bin/sh
```
