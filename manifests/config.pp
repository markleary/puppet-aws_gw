# Class: aws_gw::config
#
# This class configures strongswan and quagga
class aws_gw::config inherits aws_gw {

  file {'ipsec.conf':
    ensure  => file,
    path    => $aws_gw::params::ipsec_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/ipsec.conf.erb');
  }

  file {'ipsec.secrets':
    ensure  => file,
    path    => $aws_gw::params::secrets_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/ipsec.secrets.erb');
  }

  file {'ipsec-vti.sh':
    ensure  => file,
    path    => "${aws_gw::params::conf_path}/ipsec-vti.sh",
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('aws_gw/ipsec-vti.sh.erb');
  }

  file {'charon.conf':
    ensure  => file,
    path    => $aws_gw::params::charon_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/charon.conf.erb');
  }

  sysctl { 'net.ipv4.ip_forward':
    ensure => present,
    value  => '1',
  }
  sysctl { "net.ipv4.conf.${aws_gw::private_if}.disable_xfrm":
    ensure => present,
    value  => '1',
  }
  sysctl { "net.ipv4.conf.${aws_gw::private_if}.disable_policy":
    ensure => present,
    value  => '1',
  }
}
