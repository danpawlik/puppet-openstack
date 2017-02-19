include profiles::apt
include profiles::rabbitmq
include profiles::mysql

include openstack_integration::keystone
include openstack_integration::nova
include openstack_integration::neutron
include openstack_integration::cinder
include openstack_integration::glance
