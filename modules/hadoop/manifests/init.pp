class hadoop {
    $hadoop_root = "/usr/local"
    $hadoop_home = "${hadoop_root}/hadoop"
    $hadoop_ver = "2.4.0"
    $pack_folder = "/usr/download"
    $hadoop_user = "vagrant"

    info("starting installing hadoop ${hadoop_ver}. Path is: ${path}")     

    exec { "download_hadoop":
        command => "wget -O ${pack_folder}/hadoop-${hadoop_ver}.tgz http://apache.fis.uniroma2.it/hadoop/common/current/hadoop-${hadoop_ver}.tar.gz",
        path => $path,
        timeout => 12000,
        unless => "ls ${hadoop_root} | grep hadoop-${hadoop_ver}", 
        onlyif => "test ! -f ${pack_folder}/hadoop-${hadoop_ver}.tgz", 
        require => Package["openjdk-7-jdk"]
    }

    exec { "unpack_hadoop":
        command => "sudo tar -xzf ${pack_folder}/hadoop-${hadoop_ver}.tgz -C ${hadoop_root}",
        path => $path,
        creates => "${hadoop_home}-${hadoop_ver}",
        onlyif => "test ! -d ${hadoop_home}",
        require => Exec["download_hadoop"],
    }

    exec { "symlink_hadoop":
        command => "ln -s ${hadoop_home}-${hadoop_ver} ${hadoop_home}",
        path => $path,
        creates => "${hadoop_home}",
        require => Exec["unpack_hadoop"]
    }

    exec { "chown_hadoop":
        command => "chown -R ${hadoop_user}:${hadoop_user} ${hadoop_home}-${hadoop_ver} ${hadoop_home}",
        path => $path,
        require => Exec["symlink_hadoop"]
    }

    exec { "tmp_hadoop":
        command => "mkdir ${hadoop_home}/tmp;sudo chown ${hadoop_user}:${hadoop_user} ${hadoop_home}/tmp",
        path => $path,
        require => Exec["chown_hadoop"]
    }

    file { "${hadoop_home}/etc/hadoop/hadoop-env.sh":
        source => "/etc/puppet/files/modules/hadoop/hadoop-env.sh",
        mode => 644,
        owner => "${hadoop_user}",
        group => "${hadoop_user}",
        require => Exec["tmp_hadoop"]
    }

    file { "${hadoop_home}/etc/hadoop/core-site.xml":
        source => "/etc/puppet/files/modules/hadoop/core-site.xml",
        mode => 644,
        owner => "${hadoop_user}",
        group => "${hadoop_user}",
        require => File["${hadoop_home}/etc/hadoop/hadoop-env.sh"]
    }
    
    file { "${hadoop_home}/etc/hadoop/hdfs-site.xml":
        source => "/etc/puppet/files/modules/hadoop/hdfs-site.xml",
        mode => 644,
        owner => "${hadoop_user}",
        group => "${hadoop_user}",
        require => File["${hadoop_home}/etc/hadoop/core-site.xml"]
    }

    file { "/home/${hadoop_user}/.ssh/id_dsa":
        source => "/etc/puppet/files/modules/hadoop/id_dsa",
        mode => 600,
        owner => "${hadoop_user}",
        group => "${hadoop_user}",
        require => File["${hadoop_home}/etc/hadoop/hdfs-site.xml"]
    }
    
    file { "/home/${hadoop_user}/.ssh/id_dsa.pub":
        source => "/etc/puppet/files/modules/hadoop/id_dsa.pub",
        mode => 600,
        owner => "${hadoop_user}",
        group => "${hadoop_user}",
        require => File["/home/${hadoop_user}/.ssh/id_dsa"]
    }
    
    ssh_authorized_key { "ssh_key":
        ensure => "present",
        key => "AAAAB3NzaC1kc3MAAACBAIPPaHOG97d2F090Tbr8VZlQbpFtYadSWLdWaNAEQHSKNUgYSFCoqa1kOmf4dQCEJRMkrtyjd3TkLiKPj4i2uoRpjVi5KsaGd7AHazV9oHnRc7fFK37RDYr1KoV5orzTOXj3sl5FmUaVVz1se+HJzoeyeoIkvDDc3ekENgipSI8ZAAAAFQDh+R3PxT2BmO9d5z8hfqDao0epnwAAAIAORFTDwDGfNTGooOUrPIZ6oqFian1UP5opKpdXEd5yvAwiKV1lz2rYt/ONiYxh8xQsRiMOvrgp+ZWx2kL/dTakM6lSTA40hYlk86+AoLsYAqqkwH+hNjhUVifmI/5PyyMm2I63GwnHF7KdK3ObMdaI7PQSstyASHJaIBzsR7TMLwAAAIB68dTUY4/30NHXeWkb6aZ8LZP9qnz2LtUs8nfS+VrhP2MejZPa7wMPJ4i+3i+DdUoUIzj3sMde+WBBRMBXTjJEB0LspiqBsHHmVmDjqUAh7oBHu5vgtzQY60V6cjjIbaX+PpEp9kgH30lX4ag3YRgK6XvyhnbEBq0Z/idep16IXw==",
        type => "ssh-dss",
        user => "${hadoop_user}",
        require => File["/home/${hadoop_user}/.ssh/id_dsa.pub"]
    }
/*
    exec { "format":
        command => "${hadoop_home}/bin/hdfs namenode -format",
        path => $path,
        logoutput => true,
        require => Ssh_authorized_key["ssh_key"]
    }
*/







/*
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
        #require => Exec["jdk"]
        require => Exec["update-apt"]
    }



    exec { "unpack_hadoop":
        command => "sudo tar -xzf ${pack_folder}/hadoop.tgz -C ${hadoop_root}",
        path => $path,
        creates => "${hadoop_home}-${hadoop_ver}",
        onlyif => "test ! -d ${hadoop_home}",
        require => Exec["download_hadoop"],
    }

    exec { "rename_hadoop":
        command => "sudo mv ${hadoop_root}/hadoop-${hadoop_ver} ${hadoop_home}",
        path => $path,
        onlyif => "test -d ${hadoop_root}/hadoop-${hadoop_ver}",
        require => Exec["unpack_hadoop"]
    }
*/
/*    
    
    exec { "download_pig":
        command => "wget -O ${pack_folder}/pig.tgz http://apache.fis.uniroma2.it/pig/stable/pig-${pig_ver}.tar.gz",
        path => $path,
        timeout => 12000,
        unless => "ls ${pig_root} | grep pig-${pig_ver}", 
        onlyif => "test ! -f ${pack_folder}/pig.tgz",
        require => Exec["rename_hadoop"] 
    } 

    exec { "unpack_pig":
        command => "sudo tar -xzf ${pack_folder}/pig.tgz -C ${pig_root}",
        path => $path,
        creates => "${pig_home}-${pig_ver}",
        onlyif => "test ! -d ${pig_home}",
        require => Exec["download_pig"],
    }

    exec { "rename_pig":
        command => "sudo mv ${pig_root}/pig-${pig_ver} ${pig_home}",
        path => $path,
        onlyif => "test -d ${pig_root}/pig-${pig_ver}",
        require => Exec["unpack_pig"]
    }

    exec { "chown":
        command => "sudo chown -R vagrant ${hadoop_home}; sudo chown -R vagrant ${pig_home}",
        path => $path,
        require => Exec["rename_pig"]
    }
    
    file { "/home/vagrant/.bashrc":
        source => "/etc/puppet/files/modules/hadoop/bashrc",
        mode => 644,
        owner => root,
        group => root,
        require => Exec["chown"]
    }

    exec { "source_bashrc":
        command => "bash -c 'source /home/vagrant/.bashrc'",
        path => $path,
        require => File["/home/vagrant/.bashrc"]
    }

    file { "/home/vagrant/.ssh/id_rsa":
        source => "/etc/puppet/files/modules/hadoop/id_rsa",
        mode => 600,
        owner => vagrant,
        group => vagrant,
        require => Exec["source_bashrc"]
    }
    
    file { "/home/vagrant/.ssh/id_rsa.pub":
        source => "/etc/puppet/files/modules/hadoop/id_rsa.pub",
        mode => 600,
        owner => vagrant,
        group => vagrant,
        require => File["/home/vagrant/.ssh/id_rsa"]
    }
    
    ssh_authorized_key { "ssh_key":
        ensure => "present",
        key => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCWVEHs3iieJqbN+p8W5n1u22vF+DSiMJWhEkqgtjctqz1P0cGEcEoHyPQTjgYO33ZC8Vj+XbEYeL7tLJ7mj8ZIGFigw6x7TNnbwq8ximY5bCnksVWr04/k+PIXAjUVZrF1USyi6TUbDQ5EoFOmfJHddaPS9+AEMOD3knDBP+oQWtL4ibc/YXSqQwhYkcEGA88ouY1BvR6apber0YUdwjYR9G8N/wkpDB+pFj9EnsDl5902iiHFNJLr/wc9NqcDlkxnvNkANGMOfw2h3Ua13bqQXPa3rDUkG3ntaSSaeUXV0JkWIrFqTuezQ/VbS2l2h7RQXp5jt1JN/0F3C9M+L38b",
        type => "ssh-dss",
        user => "vagrant",
        require => File["/home/vagrant/.ssh/id_rsa.pub"]
    }


    file { "${hadoop_home}/etc/hadoop/hadoop-env.sh":
        source => "/etc/puppet/files/modules/hadoop/hadoop-env.sh",
        mode => 644,
        owner => root,
        group => root,
        require => Ssh_authorized_key["ssh_key"]
    }

    file { "${hadoop_home}/etc/hadoop/core-site.xml":
        source => "/etc/puppet/files/modules/hadoop/core-site.xml",
        mode => 644,
        owner => root,
        group => root,
        require => File["${hadoop_home}/etc/hadoop/hadoop-env.sh"]
    }

    file { "${hadoop_home}/etc/hadoop/yarn-site.xml":
        source => "/etc/puppet/files/modules/hadoop/yarn-site.xml",
        mode => 644,
        owner => root,
        group => root,
        require => File["${hadoop_home}/etc/hadoop/core-site.xml"]
    }

    file { "${hadoop_home}/etc/hadoop/mapred-site.xml":
        source => "/etc/puppet/files/modules/hadoop/mapred-site.xml",
        mode => 644,
        owner => root,
        group => root,
        require => File["${hadoop_home}/etc/hadoop/yarn-site.xml"]
    }

    exec { "mkdir_hdfs":
        command => "sudo mkdir -p /usr/local/hadoop_store/hdfs/namenode; sudo mkdir -p /usr/local/hadoop_store/hdfs/datanode",
        path => $path,
        onlyif => "test ! -d /usr/local/hadoop:store/hdfs/namenode",
        require => File["${hadoop_home}/etc/hadoop/mapred-site.xml"]
    }

    file { "${hadoop_home}/etc/hadoop/hdfs-site.xml":
        source => "/etc/puppet/files/modules/hadoop/hdfs-site.xml",
        mode => 644,
        owner => root,
        group => root,
        require => Exec["mkdir_hdfs"]
    }

    exec { "format":
      command => "${hadoop_home}/bin/hadoop namenode -format -force -noniteractive",
      path => $path,
      timeout => 12000,
      require => File["${hadoop_home}/etc/hadoop/hdfs-site.xml"]
    }
*/
}
