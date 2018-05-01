Exec { path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/' }

class basic_webserver {
	include system_update
	include apache
	include apache::enable_mods
	include apache::developer_vhost
}

class php_webserver {
	include basic_webserver
	include apache::php5
}

class ruby_webserver {
	include basic_webserver
	include brightbox_ruby
	include brightbox_ruby::install_ruby
	include brightbox_ruby::install_gems
	include apache::passenger
}

include basic_webserver