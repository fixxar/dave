install
url --url http://10.10.122.12/cblr/ks_mirror/centos-5.8-x86_64

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
ignoredisk --drives=sdb,sdc,sdd,sde,sdf,sdg,sdh,sdi,sdj,sdk,sdl,sdm

part /boot --fstype ext3 --size=500
part / --fstype ext3 --size=200000 

reboot
%pre
$SNIPPET('pre_anamon')
dd if=/dev/zero of=/dev/sda bs=512 count=1
dd if=/dev/zero of=/dev/sdb bs=512 count=1
dd if=/dev/zero of=/dev/sdc bs=512 count=1
dd if=/dev/zero of=/dev/sdd bs=512 count=1
dd if=/dev/zero of=/dev/sde bs=512 count=1
dd if=/dev/zero of=/dev/sdf bs=512 count=1
dd if=/dev/zero of=/dev/sdg bs=512 count=1
dd if=/dev/zero of=/dev/sdh bs=512 count=1
dd if=/dev/zero of=/dev/sdi bs=512 count=1
dd if=/dev/zero of=/dev/sdj bs=512 count=1
dd if=/dev/zero of=/dev/sdk bs=512 count=1
dd if=/dev/zero of=/dev/sdl bs=512 count=1
dd if=/dev/zero of=/dev/sdm bs=512 count=1
%packages
OpenIPMI
OpenIPMI-tools

%post
/usr/bin/chvt 3
wget --header="Host: changeme" http://10.10.122.11/bonding/bonding.conf -O /etc/modprobe.d/bonding.conf
wget --header="Host: changeme" http://10.10.122.11/bonding/ifcfg-eth0 -O /etc/sysconfig/network-scripts/ifcfg-eth0
wget --header="Host: changeme" http://10.10.122.11/bonding/ifcfg-eth1 -O /etc/sysconfig/network-scripts/ifcfg-eth1
cat <<EOF> /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
IPADDR=$ip_address
NETMASK=$netmask
GATEWAY=$gateway
ONBOOT=yes
BOOTPROTO=none
USERCTL=no
EOF
parted -s /dev/sda mkpart p ext3 410626048s 1875771391s
/bin/rpm -i http://10.10.122.12/cobbler/repo_mirror/brandr-repo/RPMS/epel-release-5-4.noarch.rpm
wget --header="Host: changeme" "http://10.10.122.11/system/pssc-disk-setup-58.sh" -O /usr/local/sbin/pssc-disk-setup-58.sh
echo '#bash -x /usr/local/sbin/pssc-disk-setup-58.sh > /tmp/pssc-disk-setup-58.sh.log 2>&1' >> /etc/rc.d/rc.local
$SNIPPET('post_anamon')
$SNIPPET('kickstart_done')
