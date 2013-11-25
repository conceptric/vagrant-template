class webapp ( $appname = "webapp" ) {
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
