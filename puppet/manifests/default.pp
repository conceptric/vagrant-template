Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class updated_server {
	include system-update
	include system-update::install_packages
}

class basic_webserver {
	include updated_server
	include apache
	include apache::php5
}

class ruby_webserver {
	include updated_server
	include brightbox-ruby
	include brightbox-ruby::install_ruby
	include brightbox-ruby::install_gems
	include apache
	include apache::passenger
}

include ruby_webserver
