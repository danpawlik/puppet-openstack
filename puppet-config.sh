#!/bin/bash

CLOUD_ARCHIVE_REPO='queens'
BRANCH='stable/queens'

echo "This script is installing all services on one host"
echo "Puppet will be deployed with branch: $BRANCH. If you want to change, stop the script"
for i in {10..1}; do
    echo -ne "$i..\n" && sleep 1;
done
echo "Configured branch: $BRANCH"

# Add your host into /etc/hosts.
echo "$(hostname -I | awk '{print $1}')  $(hostname) $(hostname).local" >> /etc/hosts

# Download and install puppet-4
apt-get update
apt-get install wget git -y
wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
sudo dpkg -i puppet5-release-xenial.deb

apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install puppetserver -y

hostname=$(hostname)
cat <<EOF >/etc/puppetlabs/puppet/puppet.conf
[main]
certname = $hostname
server = $hostname
environment = production
strict_variables = true

[master]
environment = production
EOF
#puppet master --genconfig > /etc/puppetlabs/puppet/puppet.conf
#puppet resource package puppetdb ensure=latest
#puppet resource service puppetdb ensure=running enable=true

export PATH=$PATH:/opt/puppetlabs/bin
echo "export PATH=$PATH:/opt/puppetlabs/bin" >> ~/.bashrc

sudo systemctl enable puppetserver
sudo systemctl stop puppetserver
sudo systemctl enable puppet
sudo systemctl stop puppet

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
git clone https://github.com/openstack/puppet-ironic.git -b $BRANCH /etc/puppetlabs/code/environments/production/modules/ironic

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
git clone https://github.com/voxpupuli/puppet-archive /etc/puppetlabs/code/environments/production/modules/archive

# Copy profile module
git clone https://github.com/dduuch/puppet-openstack.git /tmp/puppet-openstack
cp -R /tmp/puppet-openstack/profiles  /etc/puppetlabs/code/environments/production/modules/
sed s/ocata/$CLOUD_ARCHIVE_REPO/g /tmp/puppet-openstack/manifests/site.pp > /etc/puppetlabs/code/environments/production/manifests/site.pp

# Workaround with nova-common package.
echo "Workaround with nova-common installation where connection to DB is set to sqllite.
More info: https://bugs.launchpad.net/ubuntu/+source/nova/+bug/1671078"

read -p "Do you want to use workoround fix for nova? Y/n? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    cp -R /tmp/puppet-openstack/workaround-nova/nova /etc/
    echo "Fixed! :)"
fi

# Starting puppet agent
echo "Restarting puppetserver..."
sudo systemctl restart puppetserver
echo "Restarting puppet..."
sudo systemctl restart puppet
echo "Let's go puppet!"

puppetserver_name=$(ls /etc/puppetlabs/puppet/ssl/public_keys/ | sed s/\.pem//g)
/opt/puppetlabs/bin/puppet agent --test --server $puppetserver_name
