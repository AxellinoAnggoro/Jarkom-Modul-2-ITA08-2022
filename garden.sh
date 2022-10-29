echo "nameserver 192.168.122.1 #IP Ostania
nameserver 192.213.3.2 #IP Wise
nameserver 192.213.2.2 #IP Berlint 
"> /etc/resolv.conf

apt-get update
apt-get install dnsutils -y
apt-get install lynx -y
