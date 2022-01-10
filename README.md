# steamlink-archlinux
Create Archlinux boot medium for steamlink with one script!
Archlinux with Kernel 5.10.32

## Steps to install using the steamlink

1. Create `steamlink/config/system/enable_ssh.txt` and write `true` in the .txt file for enabling ssh on an USB Pendrive/Harddisk or whatever you are going to use.
	Make sure you didn't create "enable_ssh.txt.txt" in Windows.
2. ssh into your steamlink. use Putty, Powershell or whatever you want :) `ssh root@STEAMLINKIP` password: `steamlink123`
3. get the script:
`wget https://github.com/Nargajuna/steamlink-archlinux/raw/main/install.sh`
4. make it executable:
`chmod +x ./install.sh`
5. run the script
`./install.sh`


## Default passwords:

### Default user
User: `alarm`
password: `alarm`

### Root user
User: `root`
password: `root`

Q+A
There is no graphical output on the link!
SSH login is blocked for root user so ssh in adam and su for root
The Steamlink can obtain a new IP Adress, make sure you have the right one.


## Misc
Based on  https://www.reddit.com/r/Steam_Link/comments/fgew5x/running_archlinux_on_steam_link_revisited/
