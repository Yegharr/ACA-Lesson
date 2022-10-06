#!bin/sh

lastlog >  "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log" 
gzip   "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log"
