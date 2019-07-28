#!/bin/bash

zip -r lambda.zip index.rkt
aws lambda update-function-code --function-name racket-web-app \
    --zip-file fileb://lambda.zip --region us-west-2

