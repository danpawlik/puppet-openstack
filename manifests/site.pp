$release = 'ocata'

class{'profiles::apt': }
class{'profiles::rabbitmq': }
class{'profiles::mysql': }

exec { 'dist_upgrade':
  command => '/usr/bin/apt-get -q -y -o \'DPkg::Options::=--force-confold\' dist-upgrade',
}

Apt::Source["cloud-archive-${release}"] -> Exec['dist_upgrade'] -> Package<||>

class{'openstack_integration::keystone':  }  
class{'openstack_integration::nova':      } 
class{'openstack_integration::neutron':   } 
class{'openstack_integration::cinder':    } 
class{'openstack_integration::glance':    } 

class{'profiles::nova': }
class{'profiles::neutron': }
class{'profiles::cinder': }
class{'profiles::glance': }
