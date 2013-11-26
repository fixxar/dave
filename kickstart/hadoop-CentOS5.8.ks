install
url --url http://10.10.122.12/cblr/ks_mirror/centos-5.8-x86_64/

lang en_US.UTF-8
keyboard us

network --device eth0 --bootproto static --ip $ip_address --netmask $netmask --gateway $gateway --nameserver $name_servers --hostname=$hostname

rootpw --iscrypted $1$7r8pRs1G$Za3cW967lgUV/PBZG868M.
firewall --disabled
selinux --disabled
authconfig --enableshadow --enablemd5
timezone America/New_York
bootloader --location=mbr

clearpart --all --drives=sda,sdb,sdc,sdd --initlabel
#ignoredisk --drives=sdb,sdc,sdd,sde,sdf,sdg,sdh,sdi,sdj,sdk
part /boot --fstype ext3 --size=500 --ondisk=sda
part swap --size=2048 --ondisk=sda
part / --fstype ext3 --size=2000 --grow --ondisk=sda
part /data1 --fstype ext3 --size=100 --grow --ondisk=sdb
part /data2 --fstype ext3 --size=100 --grow --ondisk=sdc
part /data3 --fstype ext3 --size=100 --grow --ondisk=sdd

reboot
%packages
%post
/usr/bin/chvt 3

/bin/rm -f /etc/yum.repos.d/CentOS-Base.repo
/bin/rm -f /etc/yum.repos.d/CentOS-Debuginfo.repo
/bin/rm -f /etc/yum.repos.d/CentOS-Media.repo
curl --silent http://changeme/repos/brandr.repo -o /etc/yum.repos.d/brandr.repo
curl --silent http://changeme/repos/CentOS-Base.repo -o /etc/yum.repos.d/CentOS-Base.repo
curl --silent http://changeme/repos/jpackage50.repo -o /etc/yum.repos.d/jpackage50.repo
/usr/bin/yum clean all
/usr/bin/yum -y update
$kickstart_done
