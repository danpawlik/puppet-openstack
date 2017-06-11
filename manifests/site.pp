$release = 'ocata'

class{'profiles::apt': }
class{'profiles::rabbitmq': }
class{'profiles::mysql': }

Apt::Source["cloud-archive-${release}"] -> Package<||>

class{'openstack_integration::keystone':  }  
class{'openstack_integration::nova':      } 
class{'openstack_integration::neutron':   } 
class{'openstack_integration::cinder':    } 
class{'openstack_integration::glance':    } 

class{'profiles::nova': }
class{'profiles::neutron': }
class{'profiles::cinder': }
class{'profiles::glance': }
