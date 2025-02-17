#!/bin/bash 

[[ -z $(nmap -Pn rocky9nfs -p 2049|grep nfs|grep open) ]] && exit 1

if [[ ! -z $(df -h |grep nfsshare) ]] 
   then
	   [[ -f /usr/bin/rsync ]] && /usr/bin/rsync --bwlimit=500M --exclude='.trash*' --exclude='.cache' --exclude='.Trash*' --exclude='.Cache' --itemize-changes -avc /scratch/ /mnt/$(uname -n)/scratch/
	   [[ -f /usr/bin/rsync ]] && /usr/bin/rsync --bwlimit=500M --exclude='.trash*' --exclude='.cache' --exclude='.Trash*' --exclude='.Cache' --itemize-changes -avc /home/ /mnt/$(uname -n)/home/
   else 
	sudo rocky9nfs:/nfsshare /mnt
	if [[ -z $(df -h |grep nfsshare) ]]  
	then
	   logger info7.info "nfsshare not mounted"
	   exit 1 
   	else
	   [[ -f /usr/bin/rsync ]] && /usr/bin/rsync --bwlimit=500M --exclude='.trash*' --exclude='.cache' --exclude='.Trash*' --exclude='.Cache' --itemize-changes -avc /scratch/ /mnt/$(uname -n)/scratch/
	   [[ -f /usr/bin/rsync ]] && /usr/bin/rsync --bwlimit=500M --exclude='.trash*' --exclude='.cache' --exclude='.Trash*' --exclude='.Cache' --itemize-changes -avc /home/ /mnt/$(uname -n)/home/
fi
exit 0
