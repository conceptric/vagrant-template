class brightbox-ruby::switch_ruby ($version = "ruby2.1") {  
    exec { 'set_default_ruby':
      command   => "ruby-switch --set $version",
      require   => Package["ruby-switch"],
    } 
}