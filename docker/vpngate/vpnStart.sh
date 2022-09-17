#!/bin/sh

VPNGATE_URL=https://www.vpngate.net/api/iphone/

function global_ip {
  curl -sS https://ipinfo.io/ip
}

# vpn connect func
function connect {
  while :; do
    while read line; do
      line=$(echo $line | cut -d ',' -f 15)
      line=$(echo $line | tr -d '\r')
      openvpn <(echo "$line" | base64 -d) ;
    done < <(curl -sS $VPNGATE_URL | grep ,Japan,JP, | grep -v public-vpn- | sort -R )
  done
}

BEFORE_IP="$(global_ip)"

# connect vpn
connect &

# start proxy
privoxy <(grep -v listen-address /etc/privoxy/config ; echo listen-address 0.0.0.0:8118) &

# vpn check
while :; do
  sleep 5
  AFTER_IP=$(global_ip)
  result=$?
  echo "before=$BEFORE_IP after=$AFTER_IP"
  if [ $result -ne 0 ]; then
    pkill openvpn
  elif [ "$BEFORE_IP" = "$AFTER_IP" ]; then
    pkill openvpn
  else
    sleep 55
  fi
done
