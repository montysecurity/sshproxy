#!/bin/bash
echo "[+] IP/FQDN of device that you are making a proxy? "
read proxy

echo "[+] Username of user you have ssh access for? "
read user

echo "[+] Corresponding password? "
read pass

echo "[+] Port you want the SSH tunnel on?"
echo "[!] Pick greater than 1024 if not root"
read port

echo "[+] Making proxychains file"
cat /etc/proxychains.conf | grep -v socks | grep -v \# > proxychains.conf
echo "socks4 $proxy $port" >> proxychains.conf

echo "[+] Establishing connection"
echo "[!] If you close the SSH session, the proxy will close, suggest minimizing window"
echo "[!] You will be prompted for $user's password, enter $pass"
sshpass -p "$pass" ssh -t $user@$proxy "ssh -D 0.0.0.0:$port $user@localhost"