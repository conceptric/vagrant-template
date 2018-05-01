# Class: install_packages
# Perform system updates and install basic packages
# $sysPackages is an array of package names
#
class system_update::install_packages ( $sysPackages = [ 
    "build-essential", 
    "curl", 
    "libcurl4-openssl-dev", 
    "python-software-properties" ] ) {
		
	package { $sysPackages:
	  ensure  => "installed",
	  require => Class["system_update"],
	}
}