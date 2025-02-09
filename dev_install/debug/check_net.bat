echo off
netsh interface ipv4 show interfaces


echo look for: 
echo vEthernet (WSL (Hyper-V firewall))
echo if connected then WSL handels the network not netsh
