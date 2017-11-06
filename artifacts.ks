#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# Use network installation
url --url="http://mirror.centos.org/centos/7/os/x86_64"

# Use text based install
text
skipx
zerombr

# Skip the Setup Agent on first boot and agree to the eula
firstboot --disabled
eula --agreed

# Ensure that some services are started at boot
services --enabled=NetworkManager,sshd

# Reboot the system once the kick has completed
reboot

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network  --bootproto=static --ip=192.168.1.10 --netmask=255.255.255.0 --gateway=192.168.1.1 --nameserver=8.8.8.8 --device=em1 --noipv6 --activate
network  --bootproto=dhcp --device=em2 --onboot=off --noipv6
network  --bootproto=dhcp --device=em3 --onboot=off --noipv6
network  --bootproto=dhcp --device=em4 --onboot=off --noipv6
network  --bootproto=dhcp --device=p2p1 --onboot=off --noipv6
network  --bootproto=dhcp --device=p2p2 --onboot=off --noipv6

#network  --hostname=artifacts-01.prod.badger.net

# Root password
rootpw --iscrypted $6$Ot1vrE6MReSdq0JN$ujZquyiGJG86I3DGMGG8e6W83Gegvfzy2P7UQG5OMHhjFqriCSV6R2hA5EURGhEhm4Tx80uQ4gPEoS0LQlA.E.

# System services
services --disabled="chronyd"

# System timezone
timezone America/Chicago --isUtc --nontp

# Add the break glass user
user --groups=wheel --name=breakglass --password=$6$MnK4.MGe6UrwMtla$YRZG8jwfIUaudPTl8YYwgaeSuCl41I08vxD8ZSu55Mzqp2iHhFJjw0So2JztNuC/WZ81GCMVJfoBrrAxZpuy91 --iscrypted --gecos="Break Glass"

# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --driveorder=sda,sdb,sdc,sdd
clearpart --all --initlabel

# Create the /boot partition
part /boot/efi --fstype=efi --size=200 --ondrive=sda
part /boot --fstype=ext4 --size 1024 --asprimary --ondrive=sda

# Define pvdisk layout
part pv.os --grow --asprimary --ondrive=sda
part pv.pglogs --grow --asprimary --ondrive=sdb
part pv.pgdata --grow --asprimary --ondrive=sdc
part pv.artifacts --grow --asprimary --ondrive=sdd

# Create the OS drive layout on sda
volgroup vg_system pv.os
logvol /var --vgname=vg_system --name=lv_var --fstype=xfs --size=10240 --fsoptions="nodev"
logvol /var/log --vgname=vg_system --name=lv_varlog --fstype=xfs --size=204800 --fsoptions="nodev"
logvol /var/log/audit --vgname=vg_system --name=lv_varaudit --fstype=xfs --size=10240 --fsoptions="nodev"
logvol /tmp --vgname=vg_system --name=lv_tmp --fstype=xfs --size=10240 --fsoptions="nodev,nosuid,noexec"
logvol /home --vgname=vg_system --name=lv_home --fstype=xfs --size=51200 --fsoptions="nodev"
logvol /opt --vgname=vg_system --name=lv_opt --fstype=xfs --size=10240 --fsoptions="nodev"
logvol / --vgname=vg_system --name=lv_root --fstype=xfs --size=51200 --fsoptions="nodev"

# Create the pglogs drive layout on sdb
volgroup vg_pglogs pv.pglogs
logvol /var/lib/pgsql/pglogs --vgname=vg_pglogs --name=lv_pglogs --fstype=xfs --size=10240 --grow --fsoptions="nodev"

# Create the pgdata drive layout on sdc
volgroup vg_pgdata pv.pgdata
logvol /var/lib/pgsql/ --vgname=vg_pgdata --name=lv_pgdata --fstype=xfs --size=10240 --grow --fsoptions="nodev"

# Create the Artifacts drive layout on sdd
volgroup vg_artifacts pv.artifacts
logvol /var/opt/jfrog --vgname=vg_artifacts --name=lv_artifacts --fstype=xfs --size=10240 --grow --fsoptions="nodev"

# Install basic packages
%packages --ignoremissing
@^minimal
@core
kexec-tools
vim-enhanced
tmux
screen

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=50 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=50 --notstrict --nochanges --notempty
pwpolicy luks --minlen=6 --minquality=50 --notstrict --nochanges --notempty
%end

# Perform a full update
%post
yum update -y

yum clean all
%end


