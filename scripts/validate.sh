#!/bin/bash

sleep 60;

result=$(curl --silent --output /dev/null --write-out "%{http_code}" http://127.0.0.1:8080/hello)

if [ "$result" = 200 ]
then
    exit 0
else
    exit 1
fi