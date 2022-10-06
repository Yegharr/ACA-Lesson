#!bin/sh

lastlog >  "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log" 

bzip2 -c "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log" > "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log".bz2
zip  "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log".zip  "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log"  
gzip   "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log" > "yegharr-"`date +"%Y-%m-%d-%H-%M-%S"`".log".gz



