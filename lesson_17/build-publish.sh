#!/bin/sh
#if [("$1","$2", "$3" "$4" ,"$5") = true ] ;then

docker login --username="$1" --password="$2"
docker build -t ubuntu20."$3"  "$4" 
docker tag ubuntu20.04:"$3"  "$5"/ubuntu:20.04_"$3"
docker push yegharr/ubuntu:"$3"

#$1=username 
#$2=password 
#$3=version
#$4= Dockerfile path 
#$5=image repo name 

