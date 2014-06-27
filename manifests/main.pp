include hadoop

exec { "update-apt":
    path => ["/bin", "/usr/bin"],
    command => "sudo apt-get update",
    timeout => 12000,
    logoutput => true,
}

package { 
    ["python-software-properties","openjdk-7-jdk","vim", "git"]:
    ensure => latest,
    require => Exec['update-apt'],
}

user { "hadoop":
    password => "hadoop",
    comment => "User for hadoop processes",
    ensure => "present",
    managehome => "true",
    require => Package['openjdk-7-jdk'],
}





















/*
group { "puppet":
  ensure => "present",
}

include hadoop

exec { "update-apt":
    path => ["/bin", "/usr/bin"],
    command => "sudo apt-get update",
    timeout => 12000,
    logoutput => true,
}
*/
/*
exec { "jdk":
    path => ["/bin", "/usr/bin"],
    command => "sudo apt-get -y install default-jdk",
    require => Exec['update-apt'],
    timeout => 12000,
    logoutput => true,
}
*/
/*
package { 
    ["ssh", "rsync", "vim", "git", "ant"]:
    ensure => latest,
    #require => Exec['jdk'],
}
*/
