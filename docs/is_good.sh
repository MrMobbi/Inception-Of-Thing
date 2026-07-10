echo "KVM device:"
ls -l /dev/kvm || echo "NO /dev/kvm"

echo
echo "Virtualization flags:"
egrep -c '(vmx|svm)' /proc/cpuinfo

echo
echo "Groups:"
groups

echo
echo "Libvirt:"
systemctl is-active libvirtd

echo
echo "kvm-ok:"
sudo apt install -y cpu-checker >/dev/null 2>&1
kvm-ok
