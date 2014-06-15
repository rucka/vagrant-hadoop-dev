include hadoop

exec { "update-apt":
    path => ["/bin", "/usr/bin"],
    command => "sudo apt-get update",
    timeout => 12000,
    logoutput => true,
}

exec { "jdk":
    path => ["/bin", "/usr/bin"],
    command => "sudo apt-get -y install default-jdk",
    require => Exec['update-apt'],
    timeout => 12000,
    logoutput => true,
}

package { 
    ["vim", "git", "ant"]:
    ensure => latest,
    require => Exec['jdk'],
}

