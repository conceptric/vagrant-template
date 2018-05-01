# Class: system
#
#
class system_update {
	exec { "Get updates from remote repositories":
	  command => 'apt-get update',
	} 
}