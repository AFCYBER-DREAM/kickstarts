install
cdrom
lang en_US.UTF-8
keyboard us
unsupported_hardware
network --bootproto=dhcp
rootpw --iscrypted $6$ECz/9R4QY.ntVTOk$K3pvBjCtIrP/QZBuzUJzShgs5lNdreSm2D.egyyAfTDxcGwSGELX59gAdSxMYnqUmqwirMUkMFqB.ojx09R6C.
firewall --disabled
selinux --permissive
timezone UTC
unsupported_hardware
bootloader --location=mbr
text
skipx
zerombr
clearpart --all
part /boot --fstype=xfs --size 1000 --asprimary --ondrive=vda
part pv.01 --grow --asprimary --ondrive=vda
volgroup vg_system pv.01
logvol /var --vgname=vg_system --name=lv_var --fstype=xfs --size=4096 --fsoptions="nodev"
logvol /var/log --vgname=vg_system --name=lv_varlog --fstype=xfs --size=9216 --fsoptions="nodev"
logvol /var/log/audit --vgname=vg_system --name=lv_varaudit --fstype=xfs --size=1024 --fsoptions="nodev"
logvol /tmp --vgname=vg_system --name=lv_tmp --fstype=xfs --size=2048 --fsoptions="nodev,nosuid,noexec"
logvol /home --vgname=vg_system --name=lv_home --fstype=xfs --size=10240 --fsoptions="nodev"
logvol /opt --vgname=vg_system --name=lv_opt --fstype=xfs --size=4096 --fsoptions="nodev"
logvol / --vgname=vg_system --name=lv_root --fstype=xfs --size=1024 --grow
clearpart --all --initlabel
auth --enableshadow --passalgo=sha512 --kickstart
firstboot --disabled
eula --agreed
services --enabled=NetworkManager,sshd,acpid
reboot

%packages --ignoremissing
@Base
@Core
@Development Tools
openssh-clients
sudo
openssl-devel
readline-devel
zlib-devel
kernel-headers
kernel-devel
net-tools
vim-complete
wget
curl
rsync
nmap-ncat
acpid
tmux
screen

# unnecessary firmware
-aic94xx-firmware
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6050-firmware
-libertas-usb8388-firmware
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware
-ql2400-firmware
-ql2500-firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
%end

%post
yum update -y

yum clean all
%end

