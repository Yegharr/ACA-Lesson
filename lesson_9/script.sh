#!/bin/bash



let "VAR1=$1%5"
let "VAR2=0"

if [ "$VAR1" = "$VAR2" ]; then
	        
       	echo "Divisible"
		   
else
       	echo "NotDivisible"
			
fi
