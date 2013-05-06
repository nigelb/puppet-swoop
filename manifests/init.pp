# /etc/puppet/modules/hadoop/manifests/init.pp

class swoop($tomcat_ram = 1024)
{
	require swoop::params
	file { $swoop::params::war_directory:
		ensure => "directory",
		alias => "swoop-dir",
	}
	file {"${swoop::params::war_directory}/Swoop.war" :
		ensure  => present,
		source  => "puppet:///modules/swoop/dist/Swoop-WAR-${swoop::params::version}.war",
		alias   => "swoop-war",
		require => File["swoop-dir"]
	}
	file{"${swoop::params::context_directory}/ROOT.xml":
		alias   => "context-file",
		content => template("swoop/context/swoop.xml.erb"),
	}
	file_line{"tomcat_ram":
		path => $swoop::params::config_file,
		line => "JAVA_OPTS=\"\${JAVA_OPTS} -Xmx${tomcat_ram}\""
	}
}
