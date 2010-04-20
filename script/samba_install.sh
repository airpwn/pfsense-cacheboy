#!/bin/sh
pkg_add -r samba3
/usr/local/bin/testparm 
dl_missing () {
	echo "Downloading missing files"
	fetch http://pfsense-cacheboy.googlecode.com/files/sambalibdep.tar.gz
	tar -C / -xvf sambalibdep.tar.gz
	rm sambalibdep.tar.gz
	}
extract_config () {
	echo "Downloading config"
	fetch http://pfsense-cacheboy.googlecode.com/svn/trunk/conf/smb.conf
	mv smb.conf /usr/local/etc/smb.conf
	hostname=`hostname | sed 's/\...*//'`
	cat /usr/local/etc/smb.conf | sed s/hostname_only/$hostname/ > /usr/local/etc/smb.conf.tmp
	mv /usr/local/etc/smb.conf.tmp /usr/local/etc/smb.conf
	}
complete () {
	mv /usr/local/etc/rc.d/samba /usr/local/etc/rc.d/samba.sh
	/usr/local/etc/rc.d/samba.sh start
	hash -r
	echo "Installation Complete!"
	echo "Type password for root"
	smbpasswd -a root
	break
	}
while :
do
echo "Shared Object missing? y/n"
read YN
case $YN in
	[yY]*)
		dl_missing
		extract_config
		complete
		;;
	[nN]*)
		extract_config
		complete
		;;
esac
done