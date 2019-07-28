#!/bin/bash

docker rm runtime-container
rm -f bootstrap

docker build . --tag runtime-image
docker create -it --name runtime-container runtime-image
docker cp runtime-container:/runtime bootstrap

zip -r lambda.zip bootstrap index.rkt
aws lambda update-function-code --function-name racket-web-app --zip-file fileb://lambda.zip --region us-west-2

