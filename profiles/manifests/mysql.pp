class profiles::mysql {

  class { '::mysql::server':
    root_password           => 'a_big_secret',
    remove_default_accounts => true,
  }

}
