#!/vendor/bin/sh
wlan_mac_path=/mnt/vendor/persist/qca6750/wlan_mac.bin
wlan_dir=/mnt/vendor/persist/qca6750

if [ ! -d "$wlan_dir" ]; then
   echo "Warning: No such directory $wlan_dir."
   mkdir -p "$wlan_dir"
fi

wifi_mac=`getprop ro.vendor.trace.wifimac`
wlan_mac=$(echo "$wifi_mac" | tr -d ':')
echo "WLAN MAC from traceability partition:$wlan_mac"

if [ -f "$wlan_mac_path" ]; then
    wlanaddr=`cat /mnt/vendor/persist/qca6750/wlan_mac.bin`
    str0=$(echo  $wlanaddr | cut -c17-28)

    if [ $str0 = $wlan_mac ]; then
        echo "WLAN MAC has no changed:$str0"
    else
        echo "WLAN MAC has changed:$wlan_mac"
        if [ -n "$wlan_mac" ]; then
            echo "Intf0MacAddress="$wlan_mac > $wlan_mac_path
            echo END >> $wlan_mac_path

            echo "Set WLAN MAC:"$wlan_mac
        else
            echo "property ro.vendor.trace.wifimac is null"
        fi
    fi

else
    if [ -n "$wlan_mac" ]; then
        echo "Intf0MacAddress="$wlan_mac > $wlan_mac_path
        echo END >> $wlan_mac_path

        echo "Set WLAN MAC:"$wlan_mac
    else
        echo "property ro.vendor.trace.wifimac is null"
    fi
fi