class webapp ( $appname = "webapp" ) {
  exec { 'Update apache repository':
    command   => 'apt-get update',
  }

  file { "link_app_root":
    ensure    => "link",
    path      => "/var/$appname",
    target    => "/vagrant",
    force     => true,
    before    => File['generate_vhost'],
  }

  package { ['apache2']:
    ensure    => installed,
    require   => Exec['Update apache repository'],
    before    => File['generate_vhost'],
  }

  file { "generate_vhost":
    ensure    => file,
    path      => "/etc/apache2/sites-available/$appname",
    content   => template('webapp/apache_vhost.erb'),
    force     => true,
    owner     => "root",
    group     => "root",
    notify    => File["enable_web_application"],
  }

  file { "enable_web_application":
    ensure    => "link",
    path      => "/etc/apache2/sites-enabled/000-app",
    target    => "/etc/apache2/sites-available/$appname",
    force     => true,
    require   => File['generate_vhost'],
  }    

  service { "apache2":
    ensure    => "running",
    require   => Package['apache2'],
    subscribe => File['enable_web_application']
  }
}
