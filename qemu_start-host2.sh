#!/bin/sh
#sudo ip addr del 192.168.40.5/24 dev eno1 && sudo ip link add name br0 type bridge && sudo ip link set br0 up && sudo ip link set eno1 master br0 && sudo ip addr add 192.168.40.5/24 brd + dev br0 && sudo ip route add default via 192.168.40.1 dev br0
qemu-system-x86_64 \
-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
-smp $(nproc) \
-machine type=q35,accel=kvm \
-drive if=pflash,format=raw,unit=0,readonly=on,file=/usr/share/ovmf/x64/OVMF_CODE.fd \
-device intel-hda -device hda-duplex,audiodev=pa \
-usb \
-device usb-tablet \
-device qemu-xhci,id=xhci \
-audiodev id=pa,driver=pa,timer-period=10101,in.frequency=48000,in.buffer-length=85333,out.frequency=48000,out.buffer-length=85333,server=`pactl info | grep 'Server String' | awk '{print $3}'` \
-vga vmware \
-netdev bridge,br=br1,id=net3 -device virtio-net-pci,netdev=net3,id=nic3,mac=02:00:00:00:00:03 \
-m 4G \
-drive if=pflash,format=raw,unit=1,file=/home/lance/Projects/qemu/ovmf_vars/host2_VARS.fd \
-drive file=/mnt/data0/iso/salientos-xfce-v21.06-x86_64.iso,index=1,media=cdrom,readonly=on \
-name host2

# Run the following command on the guest to activate networking:
# sudo ip addr add 192.168.40.151/24 dev enp0s3 && sudo ip link set dev enp0s3 up && sudo ip route add default via 192.168.40.1 && sudoedit /run/systemd/resolve/stub-resolv.conf
