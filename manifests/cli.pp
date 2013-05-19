class swoop::cli(
	$cli_version = "0.0.1-SNAPSHOT",
	$cli_directory = "/root/cli"
){
	file { $cli_directory:
		ensure => "directory",
		alias => "swoop-cli-dir",
	}
	file {"/root/Swoopi_cli.tar.bz2" :
		ensure  => present,
		source  => "puppet:///modules/swoop/dist/Swoop-CommandLine-${cli_version}-deployment.tar.bz2",
		alias   => "swoop-cli-tar",
		require => File["swoop-cli-dir"]
	}
	exec{"tar xjf /root/Swoopi_cli.tar.bz2":
		cwd      => $cli_directory,
		creates  => "${cli_directory}/bin",
		require  => File["swoop-cli-dir"],
		alias    => "swoop-cli-untar",
		path     => "/usr/bin"
        }
}
