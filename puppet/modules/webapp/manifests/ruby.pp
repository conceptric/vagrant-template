class webapp::ruby ( $appname = 'webapp', $target_ruby = 'ruby2.1') {
  class { "brightbox-ruby::install_ruby": version => $target_ruby }
  
  package { ["libapache2-mod-passenger"]:
    ensure  => 'installed',
    require => Class[brightbox-ruby::switch_ruby],
    notify  => Service['apache2'],
  }

  file { "Add application tmp directory":
    path    => "/var/$appname/tmp",
    ensure  => 'directory',
    require => Class['webapp'],
    before  => Exec['Set passenger refresh on every change'],
  }

  exec { 'Set passenger refresh on every change':
    command => "touch /var/$appname/tmp/always_restart.txt",
  }  
}