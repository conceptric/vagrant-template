class brightbox-ruby::switch_ruby ($version = "ruby2.1") {  
  exec { 'set_default_ruby':
    command   => "ruby-switch --set $version",
    require   => Package["ruby-switch"],
  } 

  package { ['bundler', 'rake', 'rack']:
    ensure    => 'installed',
    provider  => gem,
    source    => "http://rubygems.org",
    require   => File['No-Rdoc'],
    subscribe => Exec['set_default_ruby'],
  }
}