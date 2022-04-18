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
2 - certificate property to retrieve in 'expire', 'serial', 'issuer' and 'fingerprint' (default: days)
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
  CERT_EXPIRE=$(true | openssl s_client -connect $1:$2 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f 2)
  CERT_EXPIRE_UT=$(date --date="$CERT_EXPIRE" +%s)
  echo "$CERT_EXPIRE_UT"
}

# Function returns certificate property
function get_cert_prop() {
  CERT_PROP=$(true | openssl s_client -connect $1:$2 2>/dev/null | openssl x509 -noout -$3 -nameopt RFC2253 | sed -r "s/^[0-9a-zA-Z ]*=\s?//")
  echo $CERT_PROP
}

case "$1" in
  "-h"|"--help")
    get_help
    exit 0
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
      exit 0
      ;;
    "sec")
      echo $(($EXPIRE - $(date +%s)))
      exit 0
      ;;
    *)
      echo "$EXPIRE"
      exit 0
      ;;
   esac
else
  echo $(get_cert_prop $HOST $PORT $PROP)
fi
