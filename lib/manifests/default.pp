# Update the list of packages ONCE before installing any packages.
exec { 'apt-update':
  command => '/usr/bin/apt-get update',
}
Exec['apt-update'] -> Package <| |>
Exec {
  path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
  logoutput => on_failure,
}

# Install Git, ZShell, GraphViz, libaugeas-ruby.
package { ['git', 'zsh', 'graphviz', 'puppet', 'augeas-tools', 'libaugeas-ruby']:
 ensure => 'installed',
}

# Apache
class { 'apache':
  mpm_module => 'prefork',
}
apache::mod { 'rewrite': } apache::mod { 'php5': }

# PHP and required modules.
include php
include php-xhprof

# Install PHP
class {[
  'php::cli',
  'php::extension::curl',
  'php::extension::mysql',
  'php::extension::memcache',
  'php::extension::apc',
  'php::extension::gd',
  'php::extension::uploadprogress',
]:}

class {'php::extension::xdebug':
  settings => [
    # Augeas commands, one command per array entry
    'set debugger/xdebug.remote_enable On',
    'set debugger/xdebug.remote_handler dbgp',
    'set debugger/xdebug.remote_connect_back On',
    'set profiler/xdebug.profiler_enable_trigger On',
    'set profiler/xdebug.profiler_output_dir /vagrant/debug/',
  ]
}

# Set up the xhprof and website (website not needed with the XHProf drupal module).
class { ['php::extension::xhprof']: } ->
file { '/usr/share/php/xhprof_html':
  ensure => directory,
} ->
apache::vhost { 'xhprof':
  servername => "xhprof.${::hostname}",
  docroot    => '/usr/share/php/xhprof_html',
  override   => 'all',
  port       => 80,
}

# Set up drush (Module: https://github.com/puphpet/puppet-drush)
class { 'drush':
  ensure => installed,
}

# Apache Sites:
file { "/var/www/${::sitename}/htdocs":
  ensure        => directory,
} ->
file { "/var/www/${::sitename}/files":
  ensure        => directory,
  owner         => vagrant,
  group         => www-data,
  mode          => 776,
} ->
file { "/var/www/${::sitename}/files_private":
  ensure        => directory,
  owner         => vagrant,
  group         => www-data,
  mode          => 770,
} ->
apache::vhost { $::sitename:
  servername    => $::hostname,
  serveraliases => ["${::hostname}.*.xip.io",],
  docroot       => "/var/www/${::sitename}/htdocs",
  override      => 'all',
  port          => 80,
}

# MySQL
class { 'mysql::client': }
class { 'mysql::bindings': }
class { 'mysql::server':
  root_password => 'drupalsql',
}

mysql::db { $::sitename:
  charset => 'utf8',
  user => 'drupal',
  password => 'drupalsql',
}
