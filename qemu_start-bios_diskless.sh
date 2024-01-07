#!/bin/sh
# Set up bridge for WAN interface
#   sudo ip link add name br0 type bridge && \
#   sudo ip tuntap add dev tap0 mode tap && \
#   sudo ip link set eno1 master br0 && \
#   sudo ip link set tap0 master br0 && \
#   sudo ip link set br0 up && \
#   sudo ip link set tap0 up promisc on && \
#   sudo ip addr del 192.168.40.5/24 dev eno1 && \
#   sudo ip addr add 192.168.40.15/24 brd + dev br0 && \
#   sudo ip addr add 192.168.40.5/24 dev tap0 && \
#   sudo ip route add default via 192.168.40.1 dev br0
qemu-system-x86_64 \
-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
-smp $(nproc) \
-machine type=q35,accel=kvm \
-usb \
-device usb-tablet \
-device qemu-xhci,id=xhci \
-device intel-hda -device hda-duplex,audiodev=pa \
-audiodev id=pa,driver=pa,timer-period=10101,in.frequency=48000,in.buffer-length=85333,out.frequency=48000,out.buffer-length=85333,server=`pactl info | grep 'Server String' | awk '{print $3}'` \
-device virtio-vga \
-netdev tap,id=net1,helper=/usr/lib/qemu/qemu-bridge-helper -device virtio-net-pci,netdev=net1,id=nic1,mac=02:00:00:00:01:06 \
-m 8G \
-drive file=/mnt/data0/vdisks/new.qcow2,format=qcow2,index=0,media=disk,if=virtio,cache=none \
-name "BIOS Diskless"

# Run the following command on the guest to activate networking:
# sudo ip addr add 192.168.40.151/24 dev enp0s3 && sudo ip link set dev enp0s3 up && sudo ip route add default via 192.168.40.1 && sudoedit /run/systemd/resolve/stub-resolv.conf

#webcam entry
#-device usb-host,vendorid=0x0c45,productid=0x6536 \

#smartcard reader
#-device usb-host,vendorid=0x04e6,productid=0xe001 \
