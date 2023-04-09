#! /bin/bash

docker build -t aws-localzone-3t-app-backend . && \
docker run -d --net=host aws-localzone-3t-app-backend

