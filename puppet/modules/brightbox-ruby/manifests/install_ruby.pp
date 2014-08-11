class brightbox-ruby::install_ruby ($version = "ruby2.1") {
  package { $version:
    ensure  => "installed",
    require => Class["brightbox-ruby"]
  } 

  package { "rubygems":
    ensure  => "installed",
    require => Package[$version]
  } 

  package { "ruby-switch":
    ensure  => "installed",
    require => Package["rubygems"]
  }   
  
  file { "No-Rdoc": 
    path    =>'/home/vagrant/.gemrc',
    ensure  => file,
    content => 'gem: --no-ri --no-rdoc',
    require => Package['rubygems'],
  }

  case $version {
    "ruby2.1":  { class { 'brightbox-ruby::switch_ruby': } }
    default:      { class { 'brightbox-ruby::switch_ruby': 
                              version => $version } } 
  }
}

