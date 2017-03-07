#!/bin/bash

BRANCH='stable/ocata'

echo "This script is installing all services on one host"

# Add your host into /etc/hosts.
echo "$(hostname -I | awk '{print $1}')  $(hostname) $(hostname).local" >> /etc/hosts

# Download and install puppet-4
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb

apt-get update
apt-get install puppetserver -y

systemctl enable puppetserver
systemctl stop puppetserver

systemctl enable puppet
systemctl stop puppet

# Clone Puppet Openstack modules
git clone https://github.com/openstack/puppet-openstack-integration.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/openstack_integration
git clone https://github.com/openstack/puppet-openstacklib.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/openstacklib
git clone https://github.com/openstack/puppet-openstack_extras.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/openstack_extras
git clone https://github.com/openstack/puppet-oslo.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/oslo
git clone https://github.com/openstack/puppet-nova.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/nova
git clone https://github.com/openstack/puppet-neutron -b $BRANCH /etc/puppetlabs/code/environments/production/modules/neutron
git clone https://github.com/openstack/puppet-keystone.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/keystone
git clone https://github.com/openstack/puppet-cinder.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/cinder
git clone https://github.com/openstack/puppet-glance.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/glance

# Clone required modules for Puppet Openstack
git clone https://github.com/puppetlabs/puppetlabs-rabbitmq.git /etc/puppetlabs/code/environments/production/modules/rabbitmq
git clone https://github.com/puppetlabs/puppetlabs-mysql.git /etc/puppetlabs/code/environments/production/modules/mysql
git clone https://github.com/puppetlabs/puppetlabs-apache.git /etc/puppetlabs/code/environments/production/modules/apache
git clone https://github.com/puppetlabs/puppetlabs-sysctl.git /etc/puppetlabs/code/environments/production/modules/sysctl
git clone https://github.com/joshuabaird/puppet-ipaclient.git /etc/puppetlabs/code/environments/production/modules/ipaclient
git clone https://github.com/puppetlabs/puppetlabs-inifile.git /etc/puppetlabs/code/environments/production/modules/inifile
git clone https://github.com/puppetlabs/puppetlabs-stdlib.git /etc/puppetlabs/code/environments/production/modules/stdlib
git clone https://github.com/puppetlabs/puppetlabs-concat.git /etc/puppetlabs/code/environments/production/modules/concat
git clone https://github.com/puppetlabs/puppetlabs-apt.git /etc/puppetlabs/code/environments/production/modules/apt
git clone https://github.com/voxpupuli/puppet-staging.git /etc/puppetlabs/code/environments/production/modules/staging
git clone https://github.com/puppetlabs/puppetlabs-vswitch.git /etc/puppetlabs/code/environments/production/modules/vswitch
git clone https://github.com/puppetlabs/puppetlabs-inifile.git /etc/puppetlabs/code/environments/production/modules/inifile

# Copy profile module
git clone https://github.com/dduuch/puppet-openstack.git /tmp/puppet-openstack
cp -R /tmp/puppet-openstack/profiles  /etc/puppetlabs/code/environments/production/modules/
cp /tmp/puppet-openstack/manifests/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp

# Starting puppet agent
systemctl start puppetserver
systemctl start puppet
/opt/puppetlabs/bin/puppet agent --test --server $(hostname).local
