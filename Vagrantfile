Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"

    config.vm.hostname = "vagrant.example.com"
    config.vm.network "private_network", ip: "10.17.3.10"
       
    config.vm.network "forwarded_port", guest: 50030, host: 51130
    config.vm.network "forwarded_port", guest: 50070, host: 51170
    config.vm.network "forwarded_port", guest: 50075, host: 51175

    config.vm.synced_folder "shared", "/home/vagrant/shared"
    config.vm.synced_folder "modules", "/etc/puppet/files/modules", mount: "puppet" 
    config.vm.synced_folder "download", "/usr/download"
    
    config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file = "main.pp"
        puppet.module_path = "modules" 
        puppet.options = "--verbose --debug"
    end 
end
