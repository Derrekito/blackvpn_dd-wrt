#!/bin/bash
#
# Connect VPN using defined server and user credentials
mkdir /tmp/blackvpn
touch /tmp/blackvpn/temp
BLACKVPN_USERNAME=''
BLACKVPN_PASSWORD=''
BLACKVPN_LOCATION='Estonia'
BLACKVPN_PROTOCOL='udp'
BLACKVPN_PORT='443'
#      Server List (as of 03-02-2017)
# Australia:        australia.vpn.blackvpn.com
# Brazil:           brazil.vpn.blackvpn.com
# Canada:           ca.vpn.blackvpn.com
# Czech Republic:   czech.vpn.blackvpn.com
# Estonia:          vpn.blackvpn.ee
# France:           vpn.blackvpn.fr
# Germany:          vpn.blackvpn.de
# Japan:            japan.vpn.blackvpn.com
# Lithuania:        vpn.blackvpn.lt
# Luxembourg:       vpn.blackvpn.lu
# Netherlands:      vpn.blackvpn.nl
# Norway:           norway.vpn.blackvpn.com
# Romania:          vpn.blackvpn.ro
# Russia:           vpn.blackvpn.ru
# Spain:            spain.vpn.blackvpn.com
# Switzerland:      vpn.blackvpn.ch
# Ukraine:          vpn.blackvpn.com.ua
# United Kingdom:   vpn.blackvpn.co.uk
# USA Central:      central.vpn.blackvpn.com
# USA East:         eastcoast.vpn.blackvpn.com
# USA West:         westcoast.vpn.blackvpn.com
case $BLACKVPN_LOCATION in
	'Australia' )
  		BLACKVPN_SERVER="australia.vpn.blackvpn.com"
  		BLACKVPN_TLSREMOTE=au
  		;;
	'Brazil' )
		BLACKVPN_SERVER="brazil.vpn.blackvpn.com"
		BLACKVPN_TLSREMOTE=br
		;;
	'Canada' )
		BLACKVPN_SERVER="ca.vpn.blackvpn.com"
		BLACKVPN_TLSREMOTE=ca
		;;
	'Czech' | 'Czech Republic' )
		BLACKVPN_SERVER="czech.vpn.blackvpn.com"
		BLACKVPN_TLSREMOTE=cz
		;;
	'Estonia' )
		echo "choosing Estonia"
		BLACKVPN_SERVER="vpn.blackvpn.ee"
		BLACKVPN_TLSREMOTE=es
		;;
	'France' )
		BLACKVPN_SERVER="vpn.blackvpn.fr"
		BLACKVPN_TLSREMOTE=fr
		;;
	'Germany' )
		BLACKVPN_SERVER="vpn.blackvpn.de"
		BLACKVPN_TLSREMOTE=de
		;;
	'Japan' )
		BLACKVPN_SERVER="japan.vpn.blackvpn.com"
		BLACKVPN_TLSREMOTE=jp
		;;
	'Lithuania' )
		BLACKVPN_SERVER="vpn.blackvpn.lt"
		BLACKVPN_TLSREMOTE=lt
		;;
	'Luxembourg' )
		BLACKVPN_SERVER="vpn.blackvpn.lu"
		BLACKVPN_TLSREMOTE=lu
	;;
	'Netherlands' )
		BLACKVPN_SERVER="vpn.blackvpn.nl"
		BLACKVPN_TLSREMOTE=nl
		;;
	'Norway' )
		BLACKVPN_SERVER="norway.vpn.blackvpn.com"
		BLACKVPN_TLSREMOTE=no
		;;
	'Romania' )
		BLACKVPN_SERVER="vpn.blackvpn.ro"
		BLACKVPN_TLSREMOTE=ro
		;;
	'Russia' )
		BLACKVPN_SERVER="vpn.blackvpn.ru"
		BLACKVPN_TLSREMOTE=ru
		;;
	'Spain' )
		BLACKVPN_SERVER="spain.vpn.blackvpn.com"
		BLACKVPN_TLSREMOTE=es
		;;
	'Switzerland' )
		BLACKVPN_SERVER="vpn.blackvpn.ch"
		BLACKVPN_TLSREMOTE=ch
		;;
	'Ukraine' )
		BLACKVPN_SERVER="vpn.blackvpn.com.ua"
		BLACKVPN_TLSREMOTE=ua
		;;
	'United Kingdom' | 'UK' )
		BLACKVPN_SERVER="vpn.blackvpn.co.uk"
		BLACKVPN_TLS=uk
		;;
	'USA Central' )
		BLACKVPN_SERVER="central.vpn.blackvpn.com"
		BLACKVPN_TLS=usa
		;;
	'USA East' )
		BLACKVPN_SERVER="eastcoast.vpn.blackvpn.com"
		BLACKVPN_TLS=usa
		;;
	'USA West' )
		BLACKVPN_SERVER="westcoast.vpn.blackvpn.com"
		BLACKVPN_TLS=usa
		;;
	*)
	echo "no matching server"
	exit 1
esac
# Turn OFF DNSMasq for DNS to prevent DNS leaks
nvram set dns_dnsmasq=0
# Set VPN as the DNS server
nvram set wan_dns=172.31.0.1
# Turn ON system log
nvram set syslogd_rem_ip=
nvram set syslogd_enable=1
nvram commit
#Start VPN setup...
mkdir /bin/blackvpn
cat > /tmp/blackvpn/user.txt << MARK1
$BLACKVPN_USERNAME
$BLACKVPN_PASSWORD
MARK1
chmod 0600 /tmp/blackvpn/user.txt
mkdir /tmp/blackvpn
cat > /tmp/blackvpn/blackvpn.conf << MARK2
client
dev tun
fast-io
persist-key
persist-tun
nobind
pull
comp-lzo
tls-client
ns-cert-type server
tls-auth /tmp/blackvpn/ta.key 1
ca /tmp/blackvpn/ca.crt
cipher AES-256-CBC
auth SHA512
key-method 2
verb 3
mute 10
auth-user-pass /tmp/blackvpn/user.txt
MARK2
cat > /tmp/blackvpn/ca.crt << MARK3
-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----
MARK3
cat > /tmp/blackvpn/ta.key << MARK4
-----BEGIN OpenVPN Static key V1-----
b790ea189139a6482df3c54dc1996921
8627b6df4d936641ad96e4a3f34e4cfb
5930684c142c0f3485c7b2633a34165d
d67d005b7148c6b26aea1e6322696e96
d81e9e6fa4b4c9bc394870e2986c59e3
6a21b700fe829d3cd01ca35d94538d5f
7194a27fac3c90f6be605e223a37fbd2
1ef499acd3aeccb79661f6f7029880d1
924b356f68cb1c7f174b55812684037d
886bb8cd81c0e524155148a10eba62e7
065b96328e977db0f5e92f27e19f6f3f
5c9480f2fff0870b4fb902d7fed50c35
7ebc4777fc57ffbca0448d2e2165af71
7182e050804283acb82350d82d0230da
ece1fc4be9eea7bdba08e24e8fa3f1d0
7b39bc883519ff38eaf4514859b824f2
-----END OpenVPN Static key V1-----
MARK4
cat > /tmp/blackvpn/blackvpndaemon << MARK5
#!/bin/sh
while :
do
NOPROCS=\`ps w | grep openvpn | grep -v grep | wc -l\`
if [ \$NOPROCS -eq 0 ]
then
/usr/sbin/openvpn --config /tmp/blackvpn/blackvpn.conf --remote $BLACKVPN_SERVER $BLACKVPN_PORT --proto $BLACKVPN_PROTOCOL --persist-remote-ip --daemon
fi
sleep 30
done
MARK5
cat > /tmp/blackvpn/smtp << MARK6
#!/bin/sh
ip rule add fwmark 99 table 2
ip route add default via $(nvram get wan_gateway) dev $(nvram get wan_ifname) table 2
MARK6
chmod a+x /tmp/blackvpn/smtp
cd /tmp/blackvpn
sleep 5
/tmp/blackvpn/smtp
chmod a+x /tmp/blackvpn/blackvpndaemon
cd /tmp/blackvpn
sleep 5
/tmp/blackvpn/blackvpndaemon &
exit 0
