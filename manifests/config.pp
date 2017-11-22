# Class: aws_gw::config
#
# This class configures strongswan and quagga
class aws_gw::config inherits aws_gw {

  $inside_vpg_1_ip = regsubst($aws_gw::inside_vpg_1,'^(\d+\.\d+\.\d+\.\d+)\/\d{1,2}$','\1')
  $inside_vpg_2_ip = regsubst($aws_gw::inside_vpg_2,'^(\d+\.\d+\.\d+\.\d+)\/\d{1,2}$','\1')

  file {'ipsec.conf':
    ensure  => file,
    path    => $aws_gw::ipsec_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/ipsec.conf.erb');
  }

  file {'ipsec.secrets':
    ensure  => file,
    path    => $aws_gw::secrets_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/ipsec.secrets.erb');
  }

  file {'ipsec-vti.sh':
    ensure  => file,
    path    => "${aws_gw::conf_path}/ipsec-vti.sh",
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('aws_gw/ipsec-vti.sh.erb');
  }

  file {'charon.conf':
    ensure  => file,
    path    => $aws_gw::charon_conf_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('aws_gw/charon.conf.erb');
  }

  file {'zebra.conf':
    ensure  => file,
    path    => $aws_gw::zebra_conf_path,
    owner   => 'quagga',
    group   => 'quagga',
    mode    => '0640',
    content => template('aws_gw/zebra.conf.erb');
  }

  file {'bgpd.conf':
    ensure  => file,
    path    => $aws_gw::bgpd_conf_path,
    owner   => 'quagga',
    group   => 'quagga',
    mode    => '0640',
    content => template('aws_gw/bgpd.conf.erb');
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
