#! /bin/bash

docker build -t aws-localzone-3t-app-backend . && \
docker run -d -p 80:8030 aws-localzone-3t-app-backend

