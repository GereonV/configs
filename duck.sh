#!/usr/bin/env bash

token=${DUCK_TOKEN:-$(cat "${0%/*}"/token 2> /dev/null)}
[ "${token}" ] || { echo "no token :("; exit 1; }
domains=( gereon )
clear_log_path=${0%/*}/duck_clear.log 
log_path=${0%/*}/duck.log 

ip6=$(ip -6 addr | grep 'inet6.*global')
ip6=${ip6#*inet6 }
ip6=${ip6%%/*}
echo "IP: ${ip6}"

for domain in "${domains[@]}"
do
	config="url=https://www.duckdns.org/update?domains=${domain}&token=${token}&verbose=true"
	echo "${config}&clear=true" | curl -o ${clear_log_path} -K -
	echo "${config}&ipv6=${ip6}" | curl -o ${log_path} -K -
	clear_log=$(cat duck_clear.log)
	log=$(cat duck.log)
	echo -e "DOMAIN: ${domain}\nCLEAR:\n${clear_log}\n==========\nLOG:\n${log}\n"
done
