class brightbox_ruby::install_ruby ($version = "ruby2.1") {
  package { $version:
    ensure  => "installed",
    require => Class["brightbox_ruby"],
  } 

  # package { "rubygems":
  #   ensure  => "installed",
  #   require => Package[$version]
  # } 

  # package { "ruby-switch":
  #   ensure  => "installed",
  #   require => Package["rubygems"]
  # }   
  
  # case $version {
  #   "ruby2.1":  { class { 'brightbox_ruby::switch_ruby': } }
  #   default:      { class { 'brightbox_ruby::switch_ruby': 
  #                             version => $version } } 
  # }
}

