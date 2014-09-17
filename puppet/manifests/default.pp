Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class basic_webserver {
	include system-update
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
	include brightbox-ruby
	include brightbox-ruby::install_ruby
	include brightbox-ruby::install_gems
	include apache::passenger
}

include ruby_webserver
