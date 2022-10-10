#!bin/ssh




lastlog >  "$(whoami)-"`date +"%Y-%m-%d-%H-%M-%S"`""

gzip   "$(whoami)-"`date +"%Y-%m-%d-%H-%M-%S"`"" > "$(whoami)-"`date +"%Y-%m-%d-%H-%M-%S"`"".gz
