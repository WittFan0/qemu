#!/bin/sh
#sudo ip addr del 192.168.40.5/24 dev eno1 && sudo ip link add name br0 type bridge && sudo ip link set br0 up && sudo ip link set eno1 master br0 && sudo ip addr add 192.168.40.5/24 brd + dev br0 && sudo ip route add default via 192.168.40.1 dev br0
qemu-system-x86_64 \
-name WinXP \
-machine pc-i440fx-6.2,accel=kvm \
-m 2G \
-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
-smp 2 \
-vga vmware \
-drive file=/mnt/data0/vdisks/winxp.qcow2,if=ide,format=qcow2,index=0,media=disk,cache=none \
-drive file=/mnt/data0/iso/Hiren\'s.BootCD.15.2.iso,if=ide,index=1,media=cdrom,cache=none \
-drive file=/mnt/data0/iso/en_windows_xp_professional_with_service_pack_3_x86_cd_vl_x14-73974.iso,if=ide,index=2,media=cdrom,cache=none \
-drive file=/mnt/data0/iso/virtio-win-0.1.225.iso,if=ide,index=3,media=cdrom,readonly=on \
-device intel-hda -device hda-duplex,audiodev=pa \
-audiodev id=pa,driver=pa,timer-period=10101,in.frequency=48000,in.buffer-length=85333,out.frequency=48000,out.buffer-length=85333,server=`pactl info | grep 'Server String' | awk '{print $3}'` \
-net nic,model=rtl8139 -net user \
-usb \
-device usb-tablet \
-device qemu-xhci,id=xhci \
-boot c
#-cpu core2duo \
#-machine type=q35,accel=kvm \
#-nic user,model=virtio-net-pci \
