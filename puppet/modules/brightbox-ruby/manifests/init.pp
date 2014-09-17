class brightbox-ruby ($repository = "ruby-ng") {
  package { 'python-software-properties':
    ensure => installed,
    require => Class["system-update"],
  }
  
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
