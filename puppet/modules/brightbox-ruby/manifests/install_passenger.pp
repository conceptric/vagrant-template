class brightbox-ruby::install_passenger {
  package { ["libapache2-mod-passenger", "passenger-common1.9.1"]:
    ensure  => 'installed',
    require => Class["brightbox-ruby::install_ruby"],
    notify  => Service["apache2"],
  }
}