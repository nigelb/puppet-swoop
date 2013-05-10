# /etc/puppet/modules/hadoop/manifests/init.pp

class swoop($tomcat_ram = "1024M")
{
	require swoop::params
	file { $swoop::params::war_directory:
		ensure => "directory",
		alias => "swoop-dir",
	}
	file {"/root/Swoop.war" :
		ensure  => present,
		source  => "puppet:///modules/swoop/dist/Swoop-WAR-${swoop::params::version}.war",
		alias   => "swoop-war",
		require => File["swoop-dir"]
	}
	exec{"unzip /root/Swoop.war":
		command  => "unzip /root/Swoop.war",
		cwd      => $swoop::params::war_directory,
		creats   => "${swoop::params::war_directory}/WEB-INF",
		require  => File["swoop-war"],
		alias    => "swoop-unzip-war",
		user     => $swoop::params::servlet_user,
		group    => $swoop::params::servlet_group,
		path     => "/usr/bin"
        }
	file{"$swoop::params::war_directory/WEB-INF/classes/hbase-site.xml":
		target  => $swoop::params::hbase_site,
		ensure  => link,
		owner   => $swoop::params::servlet_user,
		group   => $swoop::params::servlet_group,
		require => Exec["swoop-unzip-war"]
	}
	file{"$swoop::params::war_directory/WEB-INF/classes/core-site.xml":
		target  => $swoop::params::hadoop_site,
		ensure  => link,
		owner   => $swoop::params::servlet_user,
		group   => $swoop::params::servlet_group,
		require => Exec["swoop-unzip-war"]
	}
	file{"${swoop::params::context_directory}/ROOT.xml":
		alias   => "context-file",
		content => template("swoop/context/swoop.xml.erb"),
	}
	file_line{"tomcat_ram":
		path => $swoop::params::config_file,
		line => "JAVA_OPTS=\"\${JAVA_OPTS} -Xmx${tomcat_ram} -Xms${tomcat_ram}\""
	}
}
