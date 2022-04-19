# zbx-ssl
This bash script can help you to monitor some web services by retrieves SSL certificate properties.
It was written to using as Zabbix external check, but it's output is simple text, so you can use it as you want.
![alt](https://pp.userapi.com/7sJKMG95L961S_3DgIpHBKkrK2pUCMdb7aNGNA/w_tzKORcSTQ.jpg)

## Requirements
 - openssl
 - bc
 - coreutils >=5.3.0

## Usage
The scripts takes three positional parameters:
1: hostname or IP address to connect
2: Certificate property to retrieve
 - expire (default): certificate expiration date in unix timestamp by default. Can accept fotmat string after ':' with 'days', 'sec', 'iso-8601' and 'utc' presets. Also, 'days' can contains precession with '/' symbol (e.g. expire:days/4 => 42.1234)
 - serial: outputs the certificate serial number
 - issuer: outputs the issuer name
 - fingerprint: outputs the certificate SHA1 fingerprint
3: TCP port to connect (default: 443)

## Examples:
Retrieve days before certificate expires:
```bash
[root@server ~]# zbx-ssl www.google.com
1655687983
```
Expire with formatting:
```bash
[root@server ~]# zbx-ssl www.google.com expire:days
61
[root@server ~]# zbx-ssl www.google.com expire:days/2
61.82
[root@server ~]# zbx-ssl www.google.com expire:sec
5341276
[root@server ~]# zbx-ssl www.google.com expire:iso-8601
2022-06-20
[root@server ~]# zbx-ssl www.google.com expire:utc
Mon Jun 20 01:19:43 UTC 2022
```
Retrieve certificate issuer:
```bash
[root@server ~]# zbx-ssl www.google.com issuer
CN=Google Internet Authority G3,O=Google Trust Services,C=US
```

