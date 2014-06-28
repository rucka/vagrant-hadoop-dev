Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"

    config.vm.hostname = "vagrant.example.com"
    config.vm.network "private_network", ip: "10.17.3.10"
       
    config.vm.network "forwarded_port", guest: 50030, host: 50030
    config.vm.network "forwarded_port", guest: 50070, host: 50070
    config.vm.network "forwarded_port", guest: 50075, host: 50075

    #config.vm.customize [ "modifyvm", :id, "--memory", "1024"]
    config.vm"virtualbox" do |v|
        v.customize["modifyvm", :id, "--memory", "1024"]
    end

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
