class profiles::apt {

  apt::source { 'cloud-archive-ocata':
    location       => 'http://ppa.launchpad.net/ubuntu-cloud-archive/ocata-staging/ubuntu',
    release        => 'xenial',
    repos          => 'main',
    pin            => '501',
    allow_unsigned => true,
    include  => {
      'src' => true,
      'deb' => true,
    },
  }

}
