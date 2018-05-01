class apache::php5 {
  package { "php5":
  	notify  => Service['apache2'],
    ensure => latest,
    require => [Class["system_update"], Package["apache2"]],
  }
}