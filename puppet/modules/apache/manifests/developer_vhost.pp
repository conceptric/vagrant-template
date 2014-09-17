# Class: developer_vhost
#
#
class apache::developer_vhost {
	file { 'remove default vhost':
	  notify    => Service["apache2"],
	  ensure    => absent,
	  path      => "/etc/apache2/sites-enabled/000-default.conf",
	  require   => Package["apache2"],
	}    

	file { "development vhost":
	  notify    => Service["apache2"],
	  ensure    => file,
	  path      => "/etc/apache2/sites-enabled/app.conf",
	  content   => template('apache/vhost.erb'),
	  force     => true,
	  owner     => "root",
	  group     => "root",
	  require   => Package["apache2"],
	}
}