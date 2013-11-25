class webapp::ruby ( $appname = 'webapp') {
  file { "Add application tmp directory":
    path => "/var/$appname/tmp",
    ensure => 'directory',
    require => Class['webapp'],
  }

  exec { 'restart web application':
    command => "touch /var/$appname/tmp/always_restart.txt",
    require => [Package["libapache2-mod-passenger"], 
      File['Add application tmp directory']],
  }
}