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

class add_apt_brightbox ($repository = "ruby-ng") {
  exec { 'brightbox_repository':
    command => "add-apt-repository ppa:brightbox/$repository",
    require => Package["python-software-properties"]
  }

  exec { 'Updates from new repository':
    command => 'apt-get update',
    require => Exec['brightbox_repository']
  }

  notify { 'Brightbox repository added': 
    message => "Added the ${repository} Brightbox package repository.",
    require => Exec['Updates from new repository']
  }
}
 
class install_ruby_stack ($version = "ruby1.9.3") {
  package { $version:
    ensure  => "installed",
    require => Class["add_apt_brightbox"]
  } 

  package { "rubygems":
    ensure  => "installed",
    require => Package[$version]
  } 

  package { "ruby-switch":
    ensure  => "installed",
    require => Package["rubygems"]
  }   
}

class configure_ruby ($version = "ruby1.9.1") {  
  exec { 'set_default_ruby':
    command => "ruby-switch --set $version",
    require => [ 
      Package[$target_ruby], 
      Package["rubygems"], 
      Package["ruby-switch"]],
  } 

  exec { 'install_core_gems':
    command => 'gem install bundler rake --no-rdoc --no-ri',
    require => Exec['set_default_ruby'],
  } 
  
  package { ["libapache2-mod-passenger", "passenger-common1.9.1"]:
    ensure  => 'installed',
    require => Exec["set_default_ruby"],
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
  class { "add_apt_brightbox": repository => $brightbox_repository }
  class { "install_ruby_stack": version => $target_ruby }
  case $target_ruby {
    "ruby1.9.3":  { class { configure_ruby: } }
    default:      { class { configure_ruby: version => $target_ruby } } 
  }
  class { "configure_ruby_app": appname => $application_name }
}

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
include basic_webserver
include ruby_webserver