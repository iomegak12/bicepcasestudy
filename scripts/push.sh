#!/bin/bash

acrName=$1
imageName="simplewebapi"
imageTag="0.0.1"

docker push $acrName.azurecr.io/$imageName:$imageTag
