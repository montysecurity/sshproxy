#!/bin/bash

if [ "$EUID" -ne 0 ]
then
	echo "[+] Must run as root so you do not have to babysit me"
	exit
fi

echo "[+] Installing System Packages"
apt update -y
apt install ssh sshpass proxychains -y

echo "[+] Done"
