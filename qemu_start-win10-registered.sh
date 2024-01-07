#!/bin/sh
#sudo ip addr del 192.168.40.5/24 dev eno1 && sudo ip link add name br0 type bridge && sudo ip link set br0 up && sudo ip link set eno1 master br0 && sudo ip addr add 192.168.40.5/24 brd + dev br0 && sudo ip route add default via 192.168.40.1 dev br0
qemu-system-x86_64 \
-name Win10 \
-m 8G \
-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
-smp $(nproc) \
-machine type=q35,accel=kvm \
-L . \
-bios /usr/share/ovmf/x64/OVMF.fd \
-vga qxl \
-device intel-hda -device hda-duplex,audiodev=pa \
-usb \
-device usb-tablet \
-nic user,model=virtio-net-pci \
-device qemu-xhci,id=xhci \
-audiodev id=pa,driver=pa,timer-period=10101,in.frequency=48000,in.buffer-length=85333,out.frequency=48000,out.buffer-length=85333,server=`pactl info | grep 'Server String' | awk '{print $3}'` \
-drive file=/mnt/data0/vdisks/win10-registered.img,format=raw,index=0,media=disk,if=virtio,cache=none \
-boot c
