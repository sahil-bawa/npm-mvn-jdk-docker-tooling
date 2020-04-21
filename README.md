# Build Dockerfile Locally

Working directory: .

To build the docker image, type:

```
docker build -t <image-name>:<image-version> .
```

Once the image is built, list all images in system using:

```
docker image ls
```

Note the IMAGE ID of the tag you just created. To access the filesystem of the built image, run:

```
docker run -it <IMAGE_ID> /bin/bash
```

You can now access the artifacts on the filesystem and confirm build results.
