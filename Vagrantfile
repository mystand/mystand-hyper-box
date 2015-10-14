# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'nikel/vervet64'
  config.vm.hostname = 'mystand-hyper-box'

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
  config.vm.synced_folder "F:/work/projects", "/home/vagrant/projects", type: "smb", smb_password: "mystand", smb_username: "mystand", smb_host: "192.168.137.1"
  config.vm.synced_folder "F:/mystand-hyper-box", "/vagrant", type: "smb", smb_password: "mystand", smb_username: "mystand", smb_host: "192.168.137.1"
  
  config.vm.provider "hyperv" do |v|
    v.ip_address_timeout = 60
    v.cpus = 8
  end
end
