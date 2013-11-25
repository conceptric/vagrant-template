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

class configure_app ( $appname = "webapp" ) {
  $str = "<VirtualHost *:80>
    Servername    localhost
    DocumentRoot  /var/$appname/public
    <Directory    /var/$appname/public>
      Order       allow,deny
      Allow       from all
    </Directory>
  </VirtualHost>"
  
  file { "app_root":
    ensure  => "link",
    path    => "/var/$appname",
    target  => "/vagrant",
    force   => true,
  }

  file { "create_vhost":
    ensure  => present,
    path    => "/etc/apache2/sites-available/$appname",
    force   => true,
    owner   => "root",
    group   => "root",
    content => $str,
    require => Package['apache2'],
  }

  file { "enable_web_application":
    ensure  => "link",
    path    => "/etc/apache2/sites-enabled/000-app",
    target  => "/etc/apache2/sites-available/$appname",
    force   => true,
    require => File['create_vhost'],
    notify  => Service["apache2"],
  }    
}
 
class configure_ruby_app ( $appname = 'webapp') {
  file { "Add application tmp directory":
    path => "/var/$appname/tmp",
    ensure => 'directory',
    require => Class['configure_app'],
  }
  
  exec { 'restart web application':
    command => "touch /var/$appname/tmp/always_restart.txt",
    require => [Package["libapache2-mod-passenger"], 
      File['Add application tmp directory']],
  }
}

$application_name = "webapp"
$target_ruby      = "ruby1.9.3"
$brightbox_repo   = "ruby-ng"

class basic_webserver {
  class { "system_update": }
  class { "apache": }
  class { "configure_app": appname => $application_name }
}

class ruby_webserver {
  class { "brightbox-ruby": repository => $brightbox_repository }
  class { "brightbox-ruby::install_ruby": version => $target_ruby }
  class { "brightbox-ruby::install_passenger": }
  class { "configure_ruby_app": appname => $application_name }
}

include basic_webserver
include ruby_webserver