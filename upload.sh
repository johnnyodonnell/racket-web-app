#!/bin/bash

docker build . --tag app-image
docker create -it --name app-container app-image
docker cp app-container:/app .
npm install
zip -r lambda.zip index.js app node_modules/
aws lambda update-function-code --function-name racket-web-app --zip-file fileb://lambda.zip --region us-west-2

