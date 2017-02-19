#!/bin/bash

echo "Welcome in Daniel's Openstack uninstaller"

echo "Uninstalling Openstack services"
echo "Disabling Puppet agent..."
puppet agent --disable

echo "You have 10 seconds to think if you are sure that you want to
uninstall services..."

for i in {10..1}; do
    echo -ne "$i..\n" && sleep 1;
done

echo "Uninstalling..."
for i in oslo keystone* keystone nova cinder ceilometer neutron mysql rabbit \
    openvswitch-* openstack libvirt qemu sqlalchemy apache haproxy ceph glance \
    aodh barbican designate gnocchi heat horizon ironic mistral murano mysql \
    panko sahara swift tempest trove vitrage watcher zeqar; do
    packages=$(dpkg -l | grep $i | awk '{print $2}')
    for package in packages; do
        apt-get remove --purge $package -y;
    done
done

echo "Removing /etc/<OPENSTACK SERVICE> and related program dirs"
rm -rf /etc/nova
rm -rf /etc/keystone
rm -rf /etc/cinder
rm -rf /etc/neutron
rm -rf /etc/apache2
rm -rf /etc/haproxy

echo "Removing openrc file. It's important when you make some changes and
you don't know how it should look like :) "

rm /root/openrc

echo "Autoremoving packages"
apt-get autoremove -y

echo "Removing pip packages to avoid problems with dirty installation..."
pip freeze > /tmp/dump_pip
pip uninstall -r /tmp/dump_pip -y

echo "Reinstalling all python packages after uninstalling pip packages (important)"
for i in `dpkg -l | grep python | awk '{print $2}'`; do apt-get install --reinstall $i -y; done

echo "Sometimes you can have problems db sync or package installation...
Make sure that all Openstack dirs are removed"


for i in nova neutron cinder glance keystone; do
    find / -name $i -type d | grep -v puppet | xargs rm -rf
    echo "Removed folders from Openstack $i project"
done
