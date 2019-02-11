# zbx-ssl
This bash script can help you to monitor some web services by retrieves SSL certificate properties.
It was written to using as Zabbix external check, but it's output is simple text, so you can use it as you want.

## Requirements
 - openssl

## Usage
The scripts takes three positional parameters:
1: hostname or IP address to connect
2: Certificate property to retrieve
 - days (default): prints out days before certificate expired
 - serial: outputs the certificate serial number
 - issuer: outputs the issuer name
 - fingerprint: outputs the certificate SHA1 fingerprint
3: TCP port to connect (default: 443)

## Examples:
Retrieve days before certificate expires:
```bash
[root@server ~]# zbx-ssl www.google.com
42
```
The same as abobe with exact parameter:
```bash
[root@server ~]# zbx-ssl www.google.com days
42
```
Retrieve certificate issuer:
```bash
[root@server ~]# zbx-ssl www.google.com issuer
CN=Google Internet Authority G3,O=Google Trust Services,C=US
```

