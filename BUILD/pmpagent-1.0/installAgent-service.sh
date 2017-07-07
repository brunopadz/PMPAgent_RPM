#!/bin/sh 
INSTOPT=$1
if [ "X$INSTOPT" == "X" ]
then 
    echo "Usage: $0 [ install | start | stop | remove ]
                
    All these operations can be performed only by the root user.
    
    install   - to install the PMP Agent as a service so that it 
                gets started automatically during system startup.

    start     - to start the PMP Agent process. 

    stop      - to stop the PMP Agent process.
 
    remove    - to remove a previously installed PMP Agent service from
                the system and the PMP Agent will no longer be 
                started during system startup."
    exit
fi

INIT_DIR=/etc/init.d
rootuser="false"
APP_NAME="pmpagent-service"

uid=`id -u`
if [ ${uid} = 0 ]
then
  rootuser="true"
else
  rootuser="false"
fi

if [ "${rootuser}" == "false" ]
then
 echo " "
 echo "Operation can be performed only by the root user"
 echo " "
 exit 1
fi

doinstall()
{
    dir=`pwd`

    if [ -f $INIT_DIR/$APP_NAME ]
    then
        echo "PMP Agent Service already installed !"
    else
        cd /etc/init.d
        ln -sf $dir/$APP_NAME $INIT_DIR/$APP_NAME
        chmod a+x $INIT_DIR/$APP_NAME
        chmod a+x $dir/$APP_NAME
        ln -sf $INIT_DIR/$APP_NAME /etc/rc2.d/S20$APP_NAME
        ln -sf $INIT_DIR/$APP_NAME /etc/rc3.d/S20$APP_NAME
        ln -sf $INIT_DIR/$APP_NAME /etc/rc4.d/S20$APP_NAME
        ln -sf $INIT_DIR/$APP_NAME /etc/rc5.d/S20$APP_NAME
        
        ln -sf $INIT_DIR/$APP_NAME /etc/rc0.d/K20$APP_NAME
        ln -sf $INIT_DIR/$APP_NAME /etc/rc1.d/K20$APP_NAME
        ln -sf $INIT_DIR/$APP_NAME /etc/rc6.d/K20$APP_NAME

        echo "PMP Agent Service installed successfully !"
	cd - >>/dev/null
    fi
}

function douninstall()
{
    dir=`pwd`

    cp /etc/profile $dir/profile.bkup.ui
    cat $dir/profile.bkup.ui | grep -v MonitorActivities > /etc/profile
    rm -rf /var/session/bin


    if [ -f $INIT_DIR/$APP_NAME ]
    then
        rm -f $INIT_DIR/$APP_NAME
        rm -f /etc/rc2.d/S20$APP_NAME
        rm -f /etc/rc3.d/S20$APP_NAME
        rm -f /etc/rc4.d/S20$APP_NAME
        rm -f /etc/rc5.d/S20$APP_NAME

        rm -f /etc/rc0.d/K20$APP_NAME
        rm -f /etc/rc1.d/K20$APP_NAME
        rm -f /etc/rc6.d/K20$APP_NAME


        echo "PMP  Agent Service uninstalled successfully !"
    else
        echo "PMP Agent Service not installed currently"
    fi
}
function startpmp() {
	if [ -f /etc/init.d/pmpagent-service ]
	then
		/etc/init.d/pmpagent-service start
	else
		echo "PMP Agent not yet installed. Install agent and try again."
	fi
}

stoppmp() {
	echo -n "Stopping PMP Agent ....  "
	pid=`ps -C  PMPAgent -o pid | grep -v PID 2>/dev/null`
	if [ "x$pid" != "x" ]; then
		kill -9 $pid 2>/dev/null
		echo "stopped!"
	else
		echo "already stopped!"
	fi
}


if [ "${INSTOPT}" == "remove" ]
then
chmod a+x PMPAgent
chmod a+x pmpagent-service
stoppmp
douninstall
fi

if [ "${INSTOPT}" == "install" ]
then
chmod a+x PMPAgent
chmod a+x pmpagent-service
doinstall
startpmp
fi

if [ "${INSTOPT}" == "start" ]
then
chmod a+x PMPAgent
chmod a+x pmpagent-service
startpmp
fi

if [ "${INSTOPT}" == "stop" ]
then
chmod a+x PMPAgent
chmod a+x pmpagent-service
stoppmp
fi

