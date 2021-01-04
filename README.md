# sshproxy
This tool was designed with covert pentesting in mind. It it designed to mask traffic with SSH using binded ports and proxychains.

# use case
This focuses on pivoting undected (or at least, if you are detected, not much info can be derived from the traffic).

There are 3 boxes in the network, all \*nix machines. One is your attack box, the second is a box you have pwned and the third is a box you want to pwn, but you are at a delima. How do you route your traffic from the attack box, through the pwned box, to the target box?

You run this script and then prepend all following network based recon commands with "proxychains ". Take note that the script makes a proxychain.conf file, so if you move out of the working directory, bring it with you. This leverages the fact that proxychains checks the working directory for a configuration file first.

## what this is actually doing...
1. Creates a local proxychains file based on the existing one (/etc/proxychains.conf), so any custom settings are copied over and the main one is not accidentally messed up. In this file, it specifies the IP/domain and port pair that is specified during execution as a proxy
2. It connects to the IP provided with the user and password provided via SSH
3. Immediately after getting a terminal, it executes a command to create a binded port run by SSH

## blue team notes
- After the proxy is created, all SSH traffic over port 22 is the proxy sending the messages printed to STDOUT that tell the creator of the proxy the status of each connection.
- Both requests and reponses are sent through the port setup for the proxy by the attacker (ports below 1024 require privileged access to set as proxies)
- The general flow of a single request and the corresponding response follows this pattern
	1. Three way handshake
	2. Attack Box --> Proxy [PSH,ACK]
	3. Corresponding ACK
	4. Attack Box <-- Proxy [PSH,ACK]
	5. Corresponding ACK
	6. Attack Box --> Proxy [FIN,ACK]
	7. Attack Box <-- Proxy [FIN,ACK]
	8. Corresponding ACK
- If there is no reponse (e.g. you nmap a closed port), it looks as follows 
	1. Three way handshake
	2. Attack Box --> Proxy [PSH,ACK]
	3. Corresponding ACK
	4. Attack Box <-- Proxy [FIN,ACK]
	5. Attack Box --> Proxy [FIN,ACK]
	6. Corresponding ACK

## red team notes
- If the account connection is severed, you have to re-initiate the connection to turn the proxy back on
- Be aware that if there are network connection issues, it will likely expose some data in clear text
- This does not prevent blue team from identifying the source (attack box), only the destination (target)

### tools verified to work
- nmap
- nikto
- dirb
- curl
- nc (both bind and reverse shells)
