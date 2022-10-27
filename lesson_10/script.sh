#!/bin/bash
  


#f=$(ls /root/logs/ | wc -l)
#let "h=$f-10"
name=`/bin/date +"%H:%M"`

echo "================ Uptime ================"  >> /root/logs/$name.log
echo " $(uptime)" >> /root/logs/$name.log
echo "================ Lastlog ================"  >> /root/logs/$name.log
echo " $(lastlog)" >> /root/logs/$name.log
echo "================ Ifconfig ================"  >> /root/logs/$name.log
echo "$(ifconfig)" >> /root/logs/$name.log
echo "================ Disk Space Utilization ================"  >> /root/logs/$name.log
echo "$(df -H)" >> /root/logs/$name.log
echo "================ Free Memory Stats ================"  >> /root/logs/$name.log
echo " $(cat /proc/meminfo)" >> /root/logs/$name.log

f=$(ls /root/logs/ | wc -l)

let "h=$f-10"



if       [ $h -gt 0 ]; then

	  rm $(ls -dt /root/logs/*.log | tail -n $h)


fi
