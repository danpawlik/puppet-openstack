$release = 'newton'

include profiles::apt
include profiles::rabbitmq
include profiles::mysql

include openstack_integration::keystone
include openstack_integration::nova
include openstack_integration::neutron
include openstack_integration::cinder
include openstack_integration::glance

include profiles::nova
include profiles::neutron
include profiles::cinder
include profiles::glance
