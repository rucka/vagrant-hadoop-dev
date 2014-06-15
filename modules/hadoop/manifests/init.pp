class hadoop {
    $hadoop_root = "/usr/local"
    $hadoop_home = "${hadoop_root}/hadoop"
    $hadoop_ver = "2.4.0"
    $pig_root = "/usr/local"
    $pig_home = "${pig_root}/pig"
    $pig_ver = "0.12.1"
    $pack_folder = "/usr/download"

    info("starting installing hadoop ${hadoop_ver}. Path is: ${path}")     

    exec { "download_hadoop":
        command => "wget -O ${pack_folder}/hadoop.tgz http://apache.fis.uniroma2.it/hadoop/common/current/hadoop-${hadoop_ver}.tar.gz",
        path => $path,
        timeout => 12000,
        unless => "ls ${hadoop_root} | grep hadoop-${hadoop_ver}", 
        onlyif => "test ! -f ${pack_folder}/hadoop.tgz", 
        require => Exec["jdk"]
    }

    exec { "download_pig":
        command => "wget -O ${pack_folder}/pig.tgz http://apache.fis.uniroma2.it/pig/stable/pig-${pig_ver}.tar.gz",
        path => $path,
        timeout => 12000,
        unless => "ls ${pig_root} | grep pig-${pig_ver}", 
        onlyif => "test ! -f ${pack_folder}/pig.tgz",
        require => Exec["rename_hadoop"] 
    } 

    exec { "unpack_hadoop":
        command => "sudo tar -xzf ${pack_folder}/hadoop.tgz -C ${hadoop_root}",
        path => $path,
        creates => "${hadoop_home}-${hadoop_ver}",
        onlyif => "test -f ${pack_folder}/hadoop.tgz",
        require => Exec["download_hadoop"],
    }

    exec { "rename_hadoop":
        command => "sudo mv ${hadoop_root}/hadoop-${hadoop_ver} ${hadoop_home}",
        path => $path,
        onlyif => "test -d ${hadoop_root}/hadoop-${hadoop_ver}",
        require => Exec["unpack_hadoop"]
    }
    
    exec { "unpack_pig":
        command => "sudo tar -xzf ${pack_folder}/pig.tgz -C ${pig_root}",
        path => $path,
        creates => "${pig_home}-${pig_ver}",
        onlyif => "test -f ${pack_folder}/pig.tgz",
        require => Exec["download_pig"],
    }

    exec { "rename_pig":
        command => "sudo mv ${pig_root}/pig-${pig_ver} ${pig_home}",
        path => $path,
        onlyif => "test -d ${pig_root}/pig-${pig_ver}",
        require => Exec["unpack_pig"]
    }

    file { "/home/vagrant/.ssh/id_rsa":
        source => "/etc/puppet/files/modules/hadoop/id_rsa",
        mode => 600,
        owner => vagrant,
        group => vagrant,
        require => Exec["update-apt"]
    }
    
    file { "/home/vagrant/.ssh/id_rsa.pub":
        source => "/etc/puppet/files/modules/hadoop/id_rsa.pub",
        mode => 600,
        owner => vagrant,
        group => vagrant,
        require => Exec["update-apt"]
    }
    
    ssh_authorized_key { "ssh_key":
        ensure => "present",
        key => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCWVEHs3iieJqbN+p8W5n1u22vF+DSiMJWhEkqgtjctqz1P0cGEcEoHyPQTjgYO33ZC8Vj+XbEYeL7tLJ7mj8ZIGFigw6x7TNnbwq8ximY5bCnksVWr04/k+PIXAjUVZrF1USyi6TUbDQ5EoFOmfJHddaPS9+AEMOD3knDBP+oQWtL4ibc/YXSqQwhYkcEGA88ouY1BvR6apber0YUdwjYR9G8N/wkpDB+pFj9EnsDl5902iiHFNJLr/wc9NqcDlkxnvNkANGMOfw2h3Ua13bqQXPa3rDUkG3ntaSSaeUXV0JkWIrFqTuezQ/VbS2l2h7RQXp5jt1JN/0F3C9M+L38b",
        type => "ssh-dss",
        user => "vagrant",
        require => File["/home/vagrant/.ssh/id_rsa.pub"]
    }
}
