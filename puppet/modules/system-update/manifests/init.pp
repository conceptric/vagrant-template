# Class: system
#
#
class system-update {
	exec { "Get updates from remote repositories":
	  command => 'apt-get update',
	} 
}