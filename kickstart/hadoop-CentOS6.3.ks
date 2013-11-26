install
url --url http://10.10.122.12/cblr/ks_mirror/centos-6.3-x86_64

lang en_US.UTF-8
keyboard us

network --device eth0 --bootproto static --ip $ip_address --netmask $netmask --gateway $gateway --nameserver $name_servers --hostname=$hostname

rootpw --iscrypted $1$7r8pRs1G$Za3cW967lgUV/PBZG868M.
firewall --disabled
selinux --disabled
authconfig --enableshadow --enablemd5
timezone America/New_York
bootloader --location=mbr

clearpart --all --drives=sda --initlabel
ignoredisk --only-use=sda
part /boot --fstype ext3 --size=500
part swap --size=1024
#part /usr --fstype ext3 --size=4000
part / --fstype ext3 --size=2000 --grow
#part /tmp --fstype ext3 --size=2000
#part /var --fstype ext3 --size=100 --grow

reboot
%packages
%post
/usr/bin/chvt 3
#/sbin/tune2fs -m 1 /dev/sda7

#/bin/rm -f /etc/yum.repos.d/CentOS-Base.repo
#/bin/rm -f /etc/yum.repos.d/CentOS-Debuginfo.repo
#/bin/rm -f /etc/yum.repos.d/CentOS-Media.repo
#/bin/rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
#/bin/rpm --import http://cobbler1/cobbler/repo_mirror/CentOS6.0-x86_64epel/epel_gpgkey.txt
/bin/rpm -i http://10.10.122.12/cobbler/repo_mirror/brandr-repo/RPMS/epel-release-6-7.noarch.rpm
/usr/bin/yum clean all
/usr/bin/yum -y update
#/usr/bin/yum install -y rubygems ruby-rdoc ruby-shadow

