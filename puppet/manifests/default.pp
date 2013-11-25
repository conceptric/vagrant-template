Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class system_update {
  $sysPackages = [ 
    "build-essential", 
    "curl", 
    "libcurl4-openssl-dev", 
    "python-software-properties" ]
    
  exec { 'Update remote repositories':
    command => 'apt-get update',
  } 
  
  package { $sysPackages:
    ensure  => "installed",
    require => Exec["Update remote repositories"],
  }
}

class apache {
  exec { 'Update apache repository':
    command => 'apt-get update',
  }

  package { ['apache2']:
    ensure  => installed,
    require => Exec['Update apache repository'],
  }


  service { "apache2":
    ensure  => "running",
    require => Package['apache2'],
  }
}
 
$application_name = "webapp"
$target_ruby      = "ruby1.9.3"
$brightbox_repo   = "ruby-ng"

class basic_webserver {
  class { "system_update": }
  class { "apache": }
  class { "webapp": appname => $application_name }
}

class ruby_webserver {
  class { "brightbox-ruby": repository => $brightbox_repository }
  class { "brightbox-ruby::install_ruby": version => $target_ruby }
  class { "brightbox-ruby::install_passenger": }
  class { "webapp::ruby": appname => $application_name }
}

include basic_webserver
include ruby_webserver