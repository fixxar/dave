install
url --url http://10.10.122.12/cblr/ks_mirror/centos-6.4-x86_64

lang en_US.UTF-8
keyboard us

network --device eth0 --bootproto static --ip $ip_address --netmask $netmask --gateway $gateway --nameserver $name_servers --hostname=$hostname

rootpw --iscrypted $1$7r8pRs1G$Za3cW967lgUV/PBZG868M.
firewall --disabled
selinux --disabled
authconfig --enableshadow --enablemd5
timezone America/New_York
bootloader --location=mbr
#bootloader --driveorder=sda

zerombr
clearpart --all --drives=sdc --initlabel
ignoredisk --only-use=sdc
# No swap and a single root fs
part /boot --fstype ext4 --size=500
part / --fstype ext4 --size=200000 

#part /boot --fstype ext4 --onpart=/dev/sdc1
#part / --fstype ext4 --onpart=/dev/sdc2
#part /data1 --fstype ext4 --onpart=/dev/sdc3

reboot
%pre
$SNIPPET('pre_anamon')
# Handle partitioning manually
#dd if=/dev/zero of=/dev/sdc bs=512 count=1
#parted -s /dev/sdc mklabel msdos
#parted -s /dev/sdc mkpart p ext3 2048s 1026047s
#parted -s /dev/sdc  mkpart p ext3 1026048s 410626047s
#parted -s /dev/sdc mkpart p ext3 410626048s 1875771391s
%packages
OpenIPMI
OpenIPMI-tools
%post
/usr/bin/chvt 3
#/sbin/tune2fs -m 1 /dev/sda7

parted -s /dev/sdc mkpart p ext4 410626048s 703653887s 
parted -s /dev/sdc mkpart p ext4 703653889s 1875771392s

#/bin/rm -f /etc/yum.repos.d/CentOS-Base.repo
#/bin/rm -f /etc/yum.repos.d/CentOS-Debuginfo.repo
#/bin/rm -f /etc/yum.repos.d/CentOS-Media.repo
#/bin/rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
#/bin/rpm --import http://cobbler1/cobbler/repo_mirror/CentOS6.0-x86_64epel/epel_gpgkey.txt

/bin/rpm -i http://10.10.122.12/cobbler/repo_mirror/brandr-repo/RPMS/epel-release-6-7.noarch.rpm

#/usr/bin/yum clean all
#/usr/bin/yum -y update
#/usr/bin/yum install -y rubygems ruby-rdoc ruby-shadow

wget --header="Host: changeme" "http://10.10.122.11/system/pssc-disk-setup-split-ext4.sh" -O /usr/local/sbin/pssc-disk-setup.sh
echo '#bash /usr/local/sbin/pssc-disk-setup.sh > /var/tmp/pssc-disk-setup.sh.out 2>&1' >> /etc/rc.d/rc.local
wget --header="Host: changeme" "http://10.10.122.11/bonding/bonding_script" -O /tmp/bonding_script

bash /tmp/bonding_script
ping -c 1 -w 1 10.10.122.11
sleep 30
# set to boot to disk after kickstart
ipmitool chassis bootdev disk
# DONE - Close out anamon and clean up
$SNIPPET('post_anamon')
$SNIPPET('kickstart_done')
