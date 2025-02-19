#!/bin/bash 

#Check NFS Server
logger -p info7.info "Check NFS Server"
if [[ -z $(nmap -Pn rocky9nfs -p 2049|grep nfs|grep open) ]] 
   then
   logger info7.info "Check NFS Server failed"
   exit 1
fi
    
#Check NFS Server Mount
logger -p info7.info "Check NFS Mount"
sudo mount rocky9nfs:/nfsshare /mnt
if [[ -z $(df -h |grep nfsshare) ]] 
   then
   	sudo mount rocky9nfs:/nfsshare /mnt
	if [[ -z $(df -h |grep nfsshare) ]]  
	then
	   logger info7.info "nfsshare not mounted"
	   exit 1
    fi
fi 

#Backup
logger -p info7.info "Start Backup"
if [[ ! -z $(df -h |grep nfsshare) ]]
then 
    [[ -f /usr/bin/rsync ]] && /usr/bin/rsync --stats --bwlimit=500M --exclude='.trash*' --exclude='.Trash*' --exclude='Trash*' --exclude='.Cache*' --exclude='Cache*' --exclude='cache*' --exclude='.var' --itemize-changes -avcP /scratch/ /mnt/$(uname -n)/scratch/
    [[ -f /usr/bin/rsync ]] && /usr/bin/rsync --stats --bwlimit=500M --exclude='.trash*' --exclude='.Trash*' --exclude='Trash*' --exclude='.Cache*' --exclude='Cache*' --exclude='cache*' --exclude='.var' --itemize-changes -avcP /home/ /mnt/$(uname -n)/home/
logger -p info7.info "End Backup"
fi
exit 0

#UmountNFS
sudo umount rocky9nfs:/nfsshare /mnt
if [[ ! -z $(df -h |grep nfsshare) ]]
then 
    sudo umount rocky9nfs:/nfsshare /mnt
    logger -p info7.info "Umount NFS Share"
    if [[ ! -z $(df -h |grep nfsshare) ]]
       then
       logger info7.info "Umount NFS Share still mounted"
       exit 1
    fi
fi
exit 0
