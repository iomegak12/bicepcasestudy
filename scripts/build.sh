#!/bin/bash

acrPrefix=$1
imageName="simplewebapi"
imageTag="0.0.1"

docker build ./source/simplewebapi -t $acrPrefix.azurecr.io/$imageName:$imageTag