# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Set variables
  SITENAME = 'sitename'
  HOSTNAME = "#{SITENAME}.dev"
  CLIENT_IP = '192.168.34.x'
  HOST_IP = '192.168.34.1'

  DRUSH_ALIAS = 'sitename.aliases.drushrc.php'

  DOCROOT = 'site'
  SQLDUMPS = 'sqldumps'

  DRUSH_DIR = '/Users/rob/.drush'

  SYNCTYPE = 'nfs'
  VM_MEMORY = '2048'

  BOX = 'Ubuntu 12.04'
  BOX_URL = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box'

  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = BOX
  config.vm.box_url = BOX_URL

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  if SYNCTYPE == 'nfs' && (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) == nil
    config.vm.synced_folder DOCROOT, "/var/www/#{SITENAME}/htdocs",
      type: 'nfs'
    config.vm.synced_folder SQLDUMPS, '/sql',
      type: 'nfs'
  else
    # If you use this setting, be sure to run the 'vagrant rsync-auto' command
    # or create a launchd plist to auto rsync.
    config.vm.synced_folder DOCROOT, "/var/www/#{SITENAME}/htdocs",
      type: 'rsync',
      rsync__auto: true,
      rsync__args: ['--recursive', '--archive', '--delete'],
      create: true
    config.vm.synced_folder SQLDUMPS, '/sql',
      type: 'rsync',
      rsync__auto: true,
      rsync__args: ['--recursive', '--archive', '--delete'],
      create: true
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider :virtualbox do |vb, override|
    vb.name = SITENAME
    vb.customize ['modifyvm', :id, '--memory', VM_MEMORY]
  end

  config.vm.hostname = HOSTNAME
  config.vm.network :private_network, ip: CLIENT_IP

  # Update puppet to 2.7.26 and install libaugeas-ruby.
  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'lib/manifests'
    puppet.manifest_file = 'augeas.pp'
    puppet.facter = {
      'fqdn' => HOSTNAME,
    }
  end

  # config.vm.provision = 'puppet'
  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'lib/manifests'
    puppet.module_path = 'lib/modules'
    puppet.facter = {
      'sitename' => SITENAME,
      'hostname' => HOSTNAME,
      'fqdn' => HOSTNAME,
      'client_ip' => CLIENT_IP,
    }
  end

  # copy .bashrc
  config.vm.provision 'file' do |file|
    file.source = 'lib/files/.bashrc'
    file.destination = '/home/vagrant/'
  end

  # create .drush directory
  config.vm.provision 'shell', path: 'lib/files/drush.sh'

  # copy .drush config
  config.vm.provision 'file' do |file|
    file.source = "#{DRUSH_DIR}/drushrc.php"
    file.destination = '/home/vagrant/.drush/drushrc.php'
  end

  # copy .drush config
  config.vm.provision 'file' do |file|
    file.source = "#{DRUSH_DIR}/drush.ini"
    file.destination = '/home/vagrant/.drush/drushrc.ini'
  end

  # copy .drush alias
  config.vm.provision 'file' do |file|
    file.source = "#{DRUSH_DIR}/#{DRUSH_ALIAS}"
    file.destination = "/home/vagrant/.drush/#{DRUSH_ALIAS}"
  end

end
