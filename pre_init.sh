#!/bin/bash

#Colors
red="\033[00;31m"
RED="\033[01;31m"
green="\033[00;32m"
GREEN="\033[01;32m"
brown="\033[00;33m"
YELLOW="\033[01;33m"
blue="\033[00;34m"
BLUE="\033[01;34m"
purple="\033[00;35m"
PURPLE="\033[01;35m"
cyan="\033[00;36m"
CYAN="\033[01;36m"
white="\033[00;37m"
WHITE="\033[01;37m"
NC="\033[00m"

#
#${BLUE} -- 
info="[${BLUE}INFO${NC}] "
update="[${CYAN}UPDT${NC}] "
ok="[${GREEN} OK ${NC}] "
err="[${RED}ERR ${NC}] "
warn="[${YELLOW}WARN${NC}] "
#

#################################
##### MISC Settings
update_misc_settings () {
while ! test -f "${HOME}/sudo.done"; do 
  echo -e "${info}#### PERFORM THE FOLLOWING AS ROOT ###${NC}"
  echo -e "${info}## sudo visudo ${NC}"
  echo -e "${info}## Add to end of file:${NC}"
  echo -e "${info}## ${purple}${USER}  ALL=(ALL)       NOPASSWD: ALL${NC}"
  echo -e "${info}## :wq${NC}"
  echo -e "${info}######################################${NC}"
  echo -e "${brown} Press [ENTER] ONLY AFTER completing ALL of the above.${NC}" 
  read ans
  sudo visudo
  read ans
  if $(sudo cat /etc/sudoers | grep -q ${USER}); then
    touch ${HOME}/sudo.done
  fi
done
}
#################################
##### START Install Packages
update_packages () {
 while ! test -f "${HOME}/pkg.done"; do 
	 myNewPackages=()
	 sudo yum update 2&>/dev/nul
	 centos_7="gcc make perl bzip2 kernel-headers-$(uname -r) kernel-devel-$(uname -r) elfutils-libelf-devel xorg-x11-drivers xorg-x11-util screen git nano zip unzip php74-pecl-zip.x86_64 dialog"
	 centos_8_vbox="gcc make perl bzip2 kernel-headers-$(uname -r) kernel-devel-$(uname -r) elfutils-libelf-devel xorg-x11-drivers xorg-x11-utils.x86_64"
	 centos_8=$centos_8_vbox" git nano zip unzip dialog"
	 centos_9="gcc make perl bzip2 kernel-headers-$(uname -r) kernel-devel-$(uname -r) elfutils-libelf-devel xorg-x11-drivers  xorg-x11-utils.x86_64  git nano zip unzip dialog wget"
	 centos_ver=$centos_8
	 for t in $centos_ver; do  
	  if sudo yum --cacheonly list ${t} | grep -q "Available Packages";  then 
		echo -e "${update}${CYAN}Adding ${BLUE}${t}${CYAN} to install package${NC}"
		myNewPackages+=( ${t} )
	  fi
	 done
	 if [ ${#myNewPackages[@]} -gt 0 ]; then
	  echo -e "${update}${CYAN}Installing Apps: ${BLUE}${myNewPackages[@]}${NC}"
	  sudo yum -y install ${myNewPackages[@]}
	 else
	  echo -e "${ok}${GREEN}No Packages to Install${NC}"
	 fi
	 touch ${HOME}/sudo.done
 done
 
}

install_VBoxGuest () {
 #Mount and install Guest Additions
 sudo mkdir /cdrom
 while ! test -f "${HOME}/vbox.done"; do 
 rom_array=($(ls /dev/sr*))
 len=${#rom_array[@]}
 ans=99
 until [[ ! -z "${rom_array[$ans]}" ]]; do 
   for (( i=0; i<$len; i++ )); do printf "$i%s\n"  "${rom_array[$i]}" ; done
   echo -e "${brown} Which one is VBoxGuestAdditions on? (ex, if on sr1, then input  ${NC}" 
   read ans; 
 done; 
 if [ $ans -gt $len ]; then 
   echo "invalid"
 fi
 sudo mount ${rom_array[$ans]} /cdrom
 if [ test -f /cdrom/VBoxLinuxAdditions.run ]; then 
   echo "sudo /cdrom/VBoxLinuxAdditions.run"
   touch ${HOME}/vbox.done
 fi 
 done
}

update_misc_settings
update_packages
install_VBoxGuest