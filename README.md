# Liberate your macOS

- Disable SIP (Boot into recovery, open terminal, `csrutil disable`)

## prebuilt bin + extension + script method:

- chmod +x jailbreak-macos.sh

- ./jailbreak-macos.sh

## manual method:

- Build and load [hsp4](https://github.com/siguza/hsp4)

- When loading hsp4 it is crucial to make sure it is in /System/Library/Extensions/ with the proper owners and permissions

drwxr-xr-x    3 root  wheel    102 Oct 27  2018 net.siguza.hsp4.kext

- ```sudo chmod -R 755 /System/Library/Extensions/net.siguza.hsp4.kext```
- ```sudo chown -R root:wheel /System/Library/Extensions/net.siguza.hsp4.kext```

- Run this tool:
```sh
$ make clean all
$ sudo bin/nvram-liber-macos $(nm /System/Library/Kernels/kernel | egrep 'mac_policy_list$' | cut -d' ' -f1)
```

- Fully disable SIP: `sudo nvram csr-active-config='%ff%00%00%00'`

- Set bootargs to get amfi out of your way

```sudo nvram boot-args="-v cs_enforcement_disable=1 amfi_get_out_of_my_way=1 keepsyms=1 intcoproc_unrestricted=1 amfi_allow_any_signature=0"```

Also see [this thread on newosxbook forum](http://www.newosxbook.com/forum/viewtopic.php?t=16798).


## Example Success Log

```$ ./jailbreak-macos.sh 

Checking SIP Status...

Password:
Requesting load of /System/Library/Extensions/net.siguza.hsp4.kext.
/System/Library/Extensions/net.siguza.hsp4.kext loaded successfully (or already loaded).

Running liber-macos...

Assuming 0xffffff800012d498 isn't offset but unslid address
Offset is 0xa1d370
5 policies loaded
Policy #1: 'TMSafetyNet'
Policy #2: 'AMFI'
Policy #3: 'Sandbox'
Found Sandbox
Policies at 0xffffff7f85851118
Successfully nulled out Sandbox nvram policies
Policy #4: 'Quarantine'
Policy #5: 'ASP'

Disabling SIP completely...


Setting boot-args....

boot-args    -v cs_enforcement_disable=1 amfi_get_out_of_my_way=1 keepsyms=1 intcoproc_unrestricted=1 amfi_allow_any_signature=0x1

Done... please reboot...```
