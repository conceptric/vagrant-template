class apache::php5 {
  package { "php5":
    ensure => latest,
    require => [Class["system-update"], Package["apache2"]],
  }
}