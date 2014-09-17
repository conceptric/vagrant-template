# Class: apache::enable_mods
#
#
class apache::enable_mods {
	exec { "Enable mod_rewrite":
		notify  => Service['apache2'],
	  	command => "sudo a2enmod rewrite",
	  	require => Package["apache2"],
	} 
}