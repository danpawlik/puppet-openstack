class profiles::glance {

  # Create images
  glance_image { 'cirros-0.3.4-x86_64-disk':
    ensure           => present,
    container_format => 'bare',
    disk_format      => 'qcow2',
    is_public        => 'yes',
    source           => 'http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img',
    min_ram          => '64',
    min_disk         => '1024',
  }

  # Create images
  glance_image { 'CentOS-7':
    ensure           => present,
    container_format => 'bare',
    disk_format      => 'qcow2',
    is_public        => 'yes',
    source           => 'http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2',
    min_ram          => '256',
    min_disk         => '1024',
  }

  # Create images
  glance_image { 'ubuntu-xenial-server-cloudimg':
    ensure           => present,
    container_format => 'bare',
    disk_format      => 'qcow2',
    is_public        => 'yes',
    source           => 'http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img',
    min_ram          => '256',
    min_disk         => '1024',
  }

}
