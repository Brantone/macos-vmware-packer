# macOS VM Packer

This is only focussed on VM Ware Fusion.

Found that no single solution worked completely or consistently, thus for my specific use-case picked pieces from others to accomplish my goals.

Read info from [other repos listed below](#credit) for more info and alternatives.

## Note

This is not intended to promote piracy, used for development and testing.

## Build Steps

1. Download install application from Apple Store to /Applications/
2. Generate ISO
  ```
  sudo ./generate-iso.macos.sh 10.13 output
  ```
3. Run Packer
  ```
  packer build -on-error=ask packer/template.json
  ```
5. On Recovery Screen, open Disk Utility
6. Erase disk. For smaller size keep "Journaled" otherwise APFS"
7. Exit Disk Utility to return to initial screen andstart OS Install.
8. Run through macOS install manually
    * During this time packer is waiting for SSH to become available.
9. Open Terminal and manually add `vagrant` to sudoers
10. System Preferences > Remote Login > Enable "Remote Login"

### Optional

* VMWare Tools might pop-up asking about install, click "OK"
* Should the `packer` run have issues, can finish up the shrink and package manually:
  1. Stuff from my notes
  2. Shutdown VM
  3. Shrink disk
    ```
    cd output-vmware-iso
    /Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -d disk.vmdk
    /Applications/VMware\ Fusion.app/Contents/Library/vmware-vdiskmanager -k disk.vmdk
    ```
  4. Tar up
    ```
    GZIP=-9 tar cvzf your-box-name.box ./*
    ```

## To Do

* Re-add checksum
* Clean up output directories (ex: not be nested in packer folder)
* Update vmware.sh to not try to install tools if already exists
* Figure out what's going on with 'vagrant_box_directory' variable

## Credit

* https://github.com/mcandre/macos-isos
* https://github.com/mcandre/packer-templates/tree/master/macos
* https://github.com/timsutton/osx-vm-templates
( https://github.com/Sauraus/osx-vm-templates/commit/d2824572004094e7151f82bb9d75fb7d5a80efd9

### Changes
* Generate ISO
  * https://github.com/mcandre/macos-isos/blob/269b58293a8d1e2171a351cb222e16f918f4e827/lib/generate-iso.macos.sh
* Packer template
  * Started with https://github.com/timsutton/osx-vm-templates/blob/81fe5d20b48e040c1cac3a66f4eeb846f244d85e/packer/template.json
    * Deleted all the non vmware builders
    * "variables":
      * moved "variables" to the top
      * updated autologin = true
    * "builders":
      * re-arranged type, guest_os_type
      * added vm_name
      * updated guest_os_type to "darwin17-64"
      * updated memsize = 4096
      * updated numvpus = 2
    * "scripts":
      * see below
    * "post-processors":
      * added compression_level = 9
      * updated "output"
      * added vagrant_file = Vagrantfile
    * Various places:
      * deleted all references to xcode cli tools
      * deleted all references to parallels
      * deleted all references to puppet (hiera facter)
      * updated iso_url = ../output/macos-10.13.iso 
* Scripts
  * Bunch of overlap across scripts, so will be some overlap in running scripts
  * As listed in Packer template.js provisioner scripts array
  * timsutton : https://github.com/timsutton/osx-vm-templates/tree/81fe5d20b48e040c1cac3a66f4eeb846f244d85e/scripts
    * Remove parallels.sh puppet.sh xcode-cli-tools.sh
  * mcandre : https://github.com/mcandre/packer-templates/tree/d23f3c75c86b5f544790aeca80210b3f570f9e7a/macos
    * Remove fix-networking.macos.sh
    * Actually not impemented yet, still debatable what's needed
  * Sauraus : https://github.com/Sauraus/osx-vm-templates/tree/d2824572004094e7151f82bb9d75fb7d5a80efd9/scripts
    * Removed osx_config.sh
    * Replaced vagrant.sh
  * Brantone
    * Combined some things together
* Vagrantfile
  * https://github.com/mcandre/packer-templates/blob/d23f3c75c86b5f544790aeca80210b3f570f9e7a/macos/Vagrantfile
