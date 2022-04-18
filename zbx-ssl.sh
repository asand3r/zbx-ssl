#!/usr/bin/env bash
# Script version
VERSION="0.2"

HOST=$1
PROP=$2
PORT=$3

function get_help() {
echo "zbx-ssl, version: $VERSION
(c) Khatsayuk Alexander, 2019

The script takes three positional parameters:
1 - hostname or it's IP address (example: www.google.com, 192.168.1.1)
2 - certificate property to retrieve in 'expire', 'serial', 'issuer' and 'fingerprint' (default: expire:days)
3 - port to connect (default: 443)

Examples:
# Retrieve certificate expiration date in unixtime:
zbx-ssl www.google.com expire
162356256
# Expiration date can be formated with prefixes 'days' and 'sec':
zbx-ssl www.google.com expire:days
42
# Retrieve certificate issuer:
zbx-ssl www.google.com issuer
CN=Google Internet Authority G3,O=Google Trust Services,C=US

Repository on GitHub: https://github.com/asand3r/zbx-ssl"
exit 0
}

# Set defaults
if [[ -z "$PROP" ]]; then PROP="expire"; fi
if [[ -z "$PORT" ]]; then PORT=443; fi
if [[ -z "$HOST" ]]; then get_help; fi

# Function gets cert expiration date in YYYY-m-d fromat
function get_cert_expire() {
  CERT_EXPIRE=$(true | timeout 5 openssl s_client -connect $1:$2 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f 2)
  if [[ -n "$CERT_EXPIRE" ]]
  then
    CERT_EXPIRE_UT=$(date --date="$CERT_EXPIRE" +%s)
    echo "$CERT_EXPIRE_UT"
  else
    echo "-1"
  fi
}

# Function returns certificate property
function get_cert_prop() {
  CERT_PROP=$(true | timeout 5 openssl s_client -connect $1:$2 2>/dev/null | openssl x509 -noout -$3 -nameopt RFC2253 2>/dev/null | sed -r "s/^[0-9a-zA-Z ]*=\s?//")
  if [[ -n "$CERT_PROP" ]]
  then
    echo "$CERT_PROP"
  else
    echo "-1"
  fi
}

case "$1" in
  "-h"|"--help")
    get_help
    ;;
esac

# Param to display
if [[ "$PROP" =~ ^expire ]]
then
  EXPIRE_TYPE=$(echo "$PROP" | cut -d":" -f 2)
  EXPIRE=$(get_cert_expire $HOST $PORT)
  case "$EXPIRE_TYPE" in
    "days")
      echo $((($EXPIRE - $(date +%s)) / 86400))
      ;;
    "sec")
      echo $(($EXPIRE - $(date +%s)))
      ;;
    *)
      echo "$EXPIRE"
      ;;
   esac
elif [[ "$PROP" =~ ^(serial|issuer|fingerprint)$ ]]
then
  echo $(get_cert_prop $HOST $PORT $PROP)
else
  get_help
fi
exit 0
