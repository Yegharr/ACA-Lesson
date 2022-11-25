#!/bin/sh




          docker login -u $1 -p $2
	  docker build -t $3 $4 
	  docker push $3   
	  
#username = $1
#password = $2
#image_repository_name =$3
#dockerfile path = $4
#image tag= has been included in $3



