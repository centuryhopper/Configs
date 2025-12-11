#!/bin/bash
if nmcli -t -f ACTIVE,DEVICE connection show | grep -q '^yes'; then
	"$@"
else
	echo "$(date): No Wi-Fi connection; skipping job $@" >>/tmp/wifi_check.log
fi
