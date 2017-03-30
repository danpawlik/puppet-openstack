class profiles::apt {

  apt::source { "cloud-archive-${release}":
    location       => "http://ppa.launchpad.net/ubuntu-cloud-archive/${release}-staging/ubuntu",
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
