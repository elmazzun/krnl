#!/bin/bash

CPU=$(cat /proc/cpuinfo | grep "model name" | uniq | cut -d: -f2 | xargs)

# AMD Secure Virtual Machine (SVM) is the set of CPU instructions that provides
# the virtualization instruction, the one for Intel is called VMX (Virtual
# Machine Extension)
# If a CPU supports these features, certain register in the CPU are set 
if grep -q -E "vmx|svm" /proc/cpuinfo; then
    echo "Your CPU $CPU supports HW virtualization"
else
    echo "Your CPU $CPU does NOT support HW virtualization"
    exit 1
fi

# https://stackoverflow.com/a/71685427/1459065
[[ $(stat -c %G /dev/kvm) == "kvm" ]] || \
    { echo "/dev/kvm should have 'kvm' as system" && exit 1; }

# KVM may need the following tweak on the host machine to work
groups | grep -q kvm || \
    { echo "You should add $(whoami) to kvm group" && exit 1; }
groups | grep -q libvirt || \
    { echo "You should add $(whoami) to libvirt group" && exit 1; }
