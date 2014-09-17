class apache {
	include apache::developer_vhost
	include apache::enable_mods

	package { 'build-essential':
		ensure => installed,
		require => Class["system-update"],
	}
	
	package { "apache2":
		ensure  => present,
		require => Package["build-essential"],
	}

	service { "apache2":
		ensure  => "running",
		require => Package["apache2"],
	}
}
