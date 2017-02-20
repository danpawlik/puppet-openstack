class profiles::nova {

  # Create flavors
  nova_flavor { 'm1.tiny':
    ensure  => present,
    name    => 'm1.tiny',
    id      => '1',
    ram     => '512',
    disk    => '1',
    vcpus   => '1',
    require => [ Class['nova::api'], Class['nova::keystone::auth'] ],
  }

  nova_flavor { 'm1.small':
    ensure  => present,
    name    => 'm1.small',
    id      => '2',
    ram     => '2048',
    disk    => '20',
    vcpus   => '1',
    require => [ Class['nova::api'], Class['nova::keystone::auth'] ],
  }

  nova_flavor { 'm1.medium':
    ensure  => present,
    name    => 'm1.medium',
    id      => '3',
    ram     => '4096',
    disk    => '40',
    vcpus   => '2',
    require => [ Class['nova::api'], Class['nova::keystone::auth'] ],
  }

  nova_flavor { 'm1.large':
    ensure  => present,
    name    => 'm1.large',
    id      => '4',
    ram     => '8192',
    disk    => '80',
    vcpus   => '4',
    require => [ Class['nova::api'], Class['nova::keystone::auth'] ],
  }

  nova_flavor { 'm1.xlarge':
    ensure  => present,
    name    => 'm1.xlarge',
    id      => '5',
    ram     => '16348',
    disk    => '160',
    vcpus   => '8',
    require => [ Class['nova::api'], Class['nova::keystone::auth'] ],
  }

}
