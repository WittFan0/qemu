#!/bin/sh
# Set up bridge for WAN interface
#sudo ip addr del 192.168.40.5/24 dev eno1 && sudo ip link add name br0 type bridge && sudo ip link set br0 up && sudo ip link set eno1 master br0 && sudo ip addr add 192.168.40.5/24 brd + dev br0 && sudo ip route add default via 192.168.40.1 dev br0
# Set up bridge for LAN interface
#sudo ip link add name br1 type bridge && sudo ip addr add 10.0.0.1/24 dev br1 && sudo ip link set br1 up
qemu-system-x86_64 \
-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
-smp $(nproc) \
-machine type=q35,accel=kvm \
-drive if=pflash,format=raw,unit=0,readonly=on,file=/usr/share/ovmf/x64/OVMF_CODE.fd \
-usb \
-device usb-tablet \
-device qemu-xhci,id=xhci \
-device intel-hda -device hda-duplex,audiodev=pa \
-audiodev id=pa,driver=pa,timer-period=10101,in.frequency=48000,in.buffer-length=85333,out.frequency=48000,out.buffer-length=85333,server=`pactl info | grep 'Server String' | awk '{print $3}'` \
-device virtio-vga \
-netdev tap,id=net1,helper=/usr/lib/qemu/qemu-bridge-helper -device virtio-net-pci,netdev=net1,id=nic1,mac=02:00:00:00:01:08 \
-m 8G \
-drive if=pflash,format=raw,unit=1,file=/home/lance/Projects/qemu/ovmf_vars/iso_OVMF_VARS.fd \
-drive file=/mnt/data0/vdisks/new.qcow2,format=qcow2,index=0,media=disk,if=virtio,cache=none \
-drive file=/mnt/data0/iso/netboot.xyz.iso,index=1,media=cdrom,readonly=on \
-name "UEFI Netboot"

# Run the following command on the guest to activate networking:
# sudo ip addr add 192.168.40.151/24 dev enp0s3 && sudo ip link set dev enp0s3 up && sudo ip route add default via 192.168.40.1 && sudoedit /run/systemd/resolve/stub-resolv.conf

# Run the following command on the guest to activate LAN network:
# sudo ip addr add 10.0.0.1/24 dev enp0s4 && sudo ip link set dev enp0s4 up && sudo ip route add default via 192.168.40.1 && sudoedit /etc/resolv.conf

# 2nd NIC (LAN) interface
#-netdev bridge,br=br1,id=net0 -device virtio-net-pci,netdev=net0,id=nic0,mac=02:00:00:00:00:01 \

#webcam entry
#-device usb-host,vendorid=0x0c45,productid=0x6536 \

#smartcard reader
#-device usb-host,vendorid=0x04e6,productid=0xe001 \
