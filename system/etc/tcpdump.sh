#!/system/bin/sh

LOG_DIR="/sdcard/tcpdump/"
LOG_TAG="XTCLogService"

logv ()
{
  /system/bin/log -t $LOG_TAG -p v "$LOG_NAME $@"
}

mkdir -p $LOG_DIR

while [ 1 ]
do
    LOG_FILE=`date +%Y%m%d%H%M%S`.pcap
    dumpFileName="tcp_net_"$LOG_FILE".cap"

    logv "Starting tcpdump to $LOG_DIR$LOG_FILE"

    RESULT=`/system/xbin/tcpdump -i any -w $LOG_DIR$LOG_FILE`
    logv "tcpdump done, result=$RESULT"
    sleep 60
done
