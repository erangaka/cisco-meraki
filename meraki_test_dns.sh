#!/bin/bash

dns_svr=`cat /etc/resolv.conf |grep nameserver |awk '{print $2'}`
webs="meraki.com"

get_dns_status (){
  verify_url=`dig +short $2`
  if [[ ! -z $verify_url ]]; then
    qresult=`dig @${1} ${2} +time=1 +noall +answer +stats |grep 'Query time' |awk -F: '{print $2}' |awk '{print $1}'`
    if [[ ! -z $qresult ]]; then
      printf "%(%s)T,${1},succeeded,${qresult}\n"
    else
      printf "%(%s)T,${1},failed,\n"
  fi
  else
    printf "%(%s)T,${1},failed,\n"
  fi
}

while :
do
  get_dns_status $dns_svr $webs
  sleep 3600
done
