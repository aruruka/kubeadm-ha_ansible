#!/bin/bash

grub_config='/etc/default/grub'

if [[ -f $grub_config ]]; then
    echo -e "\n\e[1;36mGRUB CONFIG FILE EXISTS, NOW UPDATING KERNEL...\e[0m\n"
    tar -xzvf kernel-ml-5.0.4.tgz && cd kernel-ml-5.0.4
    yum install -y kernel-ml-5.0.4-1.el7.elrepo.x86_64.rpm
    grep -v "^#" $grub_config | grep 'GRUB_DEFAULT' && grub_default='YES' || grub_default='NO'
    if [[ $grub_default = 'YES' ]]; then
        sed -i 's@GRUB_DEFAULT=.*\$@GRUB_DEFAULT=0@g' $grub_config
    fi
    grub2-mkconfig -o /boot/grub2/grub.cfg
    echo -e "\n\e[1;32mINSTALL KERNEL RPM SUCCESSFULLY, NOW PLEASE REBOOT YOUR OS\n
    AND THEN USE 'uname -a' TO SEE KERNEL VERSION.\e[0m\n"
else
    echo -e "\n\e[1;31mGRUB CONFIG DOESN'T EXIST, SKIPPED UPDATING KERNEL...\e[0m\n"
fi
