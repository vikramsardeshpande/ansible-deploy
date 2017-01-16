#!/bin/bash
# Note:  There is some work to be done for this script  

install_user=cmdev
jumpserver=192.168.2.57
devapp=192.168.22.180
devweb=192.168.21.38


function dev_start() 
{
     nohup ssh -f -N -L 6100:${devapp}:22 ${install_user}@${jumpserver}  2>/dev/null
     nohup ssh -f -N -L 6101:${devweb}:22 ${install_user}@${jumpserver}  2>/dev/null
}  

function dev_stop() 
{
  devapp_pid=`ps -ef | grep 6100 | grep $devapp | awk '{print $2}'`;
  devweb_pid=`ps -ef | grep 6101 | grep $devweb |  awk '{print $2}'`
  kill $devapp_pid
  kill $devweb_pid
} 

 
case "$1" in
    dev_start)
        dev_start
         ;;
    dev_stop)
         dev_stop
        ;;
esac
