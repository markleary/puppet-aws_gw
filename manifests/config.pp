# Class: aws_gw::config
#
# This class configures strongswan and quagga
class aws_gw::config {
  file {'ipsec.conf':
    ensure  => file,
    path    => $aws_gw::params::ipsec_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/ipsec.conf.erb');
  }
  file {'ipsec.conf':
    ensure  => file,
    path    => $aws_gw::params::secrets_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/ipsec.secrets.erb');
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
