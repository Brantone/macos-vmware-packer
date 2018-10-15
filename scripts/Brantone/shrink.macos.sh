#!/bin/bash

# Pulled varous parts from different sources:
# https://github.com/timsutton/osx-vm-templates/blob/81fe5d20b48e040c1cac3a66f4eeb846f244d85e/scripts/shrink.sh
# https://github.com/mcandre/packer-templates/blob/d23f3c75c86b5f544790aeca80210b3f570f9e7a/macos/cleanup.macos.sh
# Note: El Cap introduced SIP so some features are removed from above

OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')

# Turn off hibernation and get rid of the sleepimage
pmset hibernatemode 0
rm -f /var/vm/sleepimage

# Stop the pager process and drop swap files. These will be re-created on boot.
# Starting with El Cap we can only stop the dynamic pager if SIP is disabled.
if [ "$OSX_VERS" -lt 11 ] || $(csrutil status | grep -q disabled); then
    launchctl unload /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
    sleep 5
fi
rm -rf /private/var/vm/swap*

# Shrink root partition
diskutil secureErase freespace 0 '/Volumes/Macintosh HD'

# VMware Fusion specific items
if [ -e .vmfusion_version ] || [[ "$PACKER_BUILDER_TYPE" == vmware* ]]; then
    # Shrink the disk
    /Library/Application\ Support/VMware\ Tools/vmware-tools-cli disk shrink /
fi

# Delete leftover VMware tool files
rm -rf /Users/vagrant/payload \
    /Users/vagrant/manifest.plist \
    /Users/vagrant/descriptor.xml \
    /Users/vagrant/com.vmware.fusion.tools.darwin.zip \
    /Users/vagrant/com.vmware.fusion.tools.darwin.zip.tar
