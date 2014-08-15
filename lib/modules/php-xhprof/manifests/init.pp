class php-xhprof {
}

class php::extension::xhprof::params {
  $ensure   = $php::params::ensure
  $package  = 'xhprof-beta'
  $provider = 'pecl'
  $inifile  = "${php::params::config_root_ini}/xhprof.ini"
  $settings = [
    'set ".anon/extension" "xhprof.so"'
  ]
}

class php::extension::xhprof(
  $ensure   = $php::extension::xhprof::params::ensure,
  $package  = $php::extension::xhprof::params::package,
  $provider = $php::extension::xhprof::params::provider,
  $inifile  = $php::extension::xhprof::params::inifile,
  $settings = $php::extension::xhprof::params::settings
) inherits php::extension::xhprof::params {

  php::extension { 'xhprof':
    ensure   => $ensure,
    package  => $package,
    provider => $provider
  }

  php::config { 'php-extension-xhprof':
    file    => $inifile,
    config  => $settings
  }
}
