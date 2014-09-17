class apache::passenger { 
  package { ["libapache2-mod-passenger"]:
    notify  => Service['apache2'],
    ensure  => 'installed',
    require => Class["brightbox-ruby::install_ruby"],
  }

  file { "Add application tmp directory":
    path    => "/var/www/app/tmp",
    ensure  => 'directory',
    require => Package['libapache2-mod-passenger'],
    before  => Exec['Set passenger refresh on every change'],
  }

  exec { 'Set passenger refresh on every change':
    command => "touch /var/www/app/tmp/always_restart.txt",
    require => File["Add application tmp directory"],
  }  
}