# Class: brightbox-ruby::install_gems
#
#
class brightbox-ruby::install_gems {
	file { "No-Rdoc": 
	  path    =>'/home/vagrant/.gemrc',
	  ensure  => file,
	  content => 'gem: --no-ri --no-rdoc',
	  require => Class["brightbox-ruby::install_ruby"],
	}

	package { ['bundler', 'rake', 'rack']:
	  ensure    => 'installed',
	  provider  => gem,
	  source    => "http://rubygems.org",
	  require   => File['No-Rdoc'],
	}
}