#!/bin/bash
# A script to update and install any upgrades automatically.
# Add this to /etc/cron.daily to run the script every 24 hours.
#chmod +x updateUbuntuServer.bash
#sudo chown root:root updateUbuntuServer.bash
#sudo mv autoupdate /etc/cron.daily

#This prevents "TERM is not set, so the dialog frontend is not usable." error
#PATH="$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

#Change the path for your directory
myPath="/home/bh/tmpServerUpdate"

logDate=$(date +"%Y-%m-%d")
logFile="$logDate"_update.log
green=$(tput setaf 2)
resetColor=$(tput sgr0)

#if not root, run as root
#if (( $EUID != 0 )); then
#    sudo /home/bh/updateUbuntuServer.bash
#    echo $green"Run as root"resetColor
#    exit
#fi

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean

#
if [ ! -d $myPath ] 
then
	mkdir -p "$myPath"
fi

cat <<- EOF > $myPath/$logFile
	This report was automatically generated by the updateUbuntuServer script."
	It contains a brief summery of installed updates and system reboot.
EOF

zgrep "$logDate.*\ installed\ " /var/log/dpkg.log* >> $myPath/$logFile

if [ -f /var/run/reboot-required ]; then
    echo $green"The system has rebooted"$resetColor >> $myPath/$logFile
    sudo reboot
fi



