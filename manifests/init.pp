# /etc/puppet/modules/hadoop/manifests/init.pp

class swoop($tomcat_ram = "1024M")
{
	file { $swoop::params::war_directory:
		ensure => "directory",
		alias => "Swoop-dir",
	}
	file {"${swoop::params::war_directory}/Swoop.war" :
		ensure  => present,
		source  => "puppet:///modules/swoop/dist/Swoop-WAR-${swoop::params::version}.war",
		alias   => "swoop-war",
		require => "swoop-dir"
	}
	file{"${swoop::params::context_directory}/Swoop.xml":
		alias   => "context-file",
		content => template("context/swoop.xml.erb"),
	}
	file_line{"tomcat_ram":
		path => $swoop::params::config_file,
		line => "JAVA_OPTS=\${JAVA_OPTS} -Xmx${tomcat_ram} -Xms${tomcat_ram}"
	}
}
