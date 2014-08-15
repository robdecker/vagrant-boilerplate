# Update the list of packages ONCE before installing any packages.
exec { "apt-update":
  command => "wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb && dpkg -i puppetlabs-release-precise.deb && apt-get update",
}
Exec["apt-update"] -> Package <| |>
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# Install the latest puppet and Augeas.
package { ['libaugeas-ruby', 'libaugeas-dev', 'augeas-tools', 'debconf-utils']:
 ensure => "installed"
}


# Make sure we have an updated version of puppet.
package { "facter":
  ensure => '1.7.6-1puppetlabs1',
  require => Package["debconf-utils"],
} ->
package { "puppet-common":
  ensure => '2.7.26-1puppetlabs1',
}
package { "puppet":
  ensure => '2.7.26-1puppetlabs1',
}
