#! /bin/bash
/opt/apache-tomcat-7.0.78/bin/check-multicast.sh
/opt/apache-tomcat-7.0.78/bin/serverStatus.sh
#echo $?
serverStatus=$?
if [ $serverStatus == "0" ]
then
  #echo "server is running"
  /opt/apache-tomcat-7.0.78/bin/catalina.sh stop
  tomcatProcesses=$(ps x |grep catalina |grep tomcat |grep -v grep)
  if [ -n "$tomcatProcesses" ]
  then
    #echo "there are still tomcat running, kill them all"
    ps -ef|grep catalina |grep tomcat |grep -v grep|cut -c 9-15|xargs kill -9 
  fi
  /opt/apache-tomcat-7.0.78/bin/catalina.sh start
elif [ $serverStatus == "2" ]
then
  statusMsg=$(tail -n 5 /opt/apache-tomcat-7.0.78/logs/catalina.out|grep 'Deploying web application')
  echo "server is still starting"
else
  #echo "server is down"
 /opt/apache-tomcat-7.0.78/bin/catalina.sh start
fi
