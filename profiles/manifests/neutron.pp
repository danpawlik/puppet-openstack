class profiles::neutron {

  # Create Neutron networks
  # https://github.com/openstack/puppet-neutron/blob/master/examples/base_provision.pp

  neutron_network { 'public':
    ensure          => present,
    router_external => 'True',
    tenant_name     => 'admin',
  }

  neutron_subnet { 'public_subnet':
    ensure       => 'present',
    cidr         => '172.24.4.224/28',
    network_name => 'public',
    tenant_name  => 'admin',
  }

  keystone_tenant { 'demo':
    ensure => present,
  }

  neutron_network { 'private':
    ensure      => present,
    tenant_name => 'demo',
  }

  neutron_subnet { 'private_subnet':
    ensure       => present,
    cidr         => '10.0.0.0/24',
    network_name => 'private',
    tenant_name  => 'demo',
  }

  # Tenant-private router - assumes network namespace isolation
  neutron_router { 'demo_router':
    ensure               => present,
    tenant_name          => 'demo',
    gateway_network_name => 'public',
    require              => Neutron_subnet['public_subnet'],
  }

  neutron_router_interface { 'demo_router:private_subnet':
    ensure => present,
  }

}
