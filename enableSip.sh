#!/bin/bash

step='undefined'

#set -e
# set trap to help debug any build errors
#trap "echo '** ERROR with build:'; pwd" INT TERM EXIT

myvar=`csrutil status | grep Apple | grep enabled`
length=${#myvar}

step='SIP STATUS'

echo""
echo "Checking SIP Status..."
echo ""

if [ $length -ne 0 ]; then
	echo 'sip enabled, please disable sip first before proceeding!'
	exit 0
fi

HSP4=/System/Library/Extensions/net.siguza.hsp4.kext

step='INSTALLING HSP4'

if [ ! -d "$HSP4" ]; then
	echo 'Installing hsp4 kext..'
	sudo cp -r Extensions/net.siguza.hsp4.kext $HSP4
	sudo chmod -R 755 $HSP4
	sudo chown -R root:wheel $HSP4
	sudo kextload -v $HSP4
	echo ""
else
	 sudo chmod -R 755 $HSP4
	 sudo chown -R root:wheel $HSP4
	 sudo kextload -v $HSP4
	 echo ""
fi

step='RUNNING LIBERIOS'

echo 'Running liber-macos...'
echo ""
sudo bin/nvram-liber-macos $(nm /System/Library/Kernels/kernel | egrep 'mac_policy_list$' | cut -d' ' -f1)

step='DISABLING SIP'

echo ""
echo 'Disabling SIP completely...'
echo ""
sudo nvram csr-active-config='%ff%00%00%00'

step='SETTING BOOT-ARGS'

echo ""
echo 'Setting boot-args....'
echo ""
sudo nvram boot-args="-v cs_enforcement_disable=1 amfi_get_out_of_my_way=1 keepsyms=1 intcoproc_unrestricted=1 amfi_allow_any_signature=0x1" 

nvram boot-args
echo ""
echo 'Done... please reboot...'
echo ""

trap - INT TERM EXIT

