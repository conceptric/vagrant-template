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

$application_name = "webapp"
$target_ruby      = "ruby2.1"
$brightbox_repo   = "ruby-ng"

class basic_webserver {
  class { "system_update": }
  class { "webapp": appname => $application_name }
}

class ruby_webserver {
  class { "brightbox-ruby": repository => $brightbox_repository }
  class { "webapp::ruby": 
    appname     => $application_name,
    target_ruby => $target_ruby }
}

include basic_webserver
include ruby_webserver