# Class: aws_gw::config
#
# This class configures iptables using the Firewall module
class aws_gw::firewall inherits aws_gw {

  firewall { '110 Set MARK for GW1':
    chain       => 'INPUT',
    table       => 'mangle',
    source      => $aws_gw::outside_vpg_1,
    destination => $aws_gw::outside_cg,
    proto       => 'esp',
    set_mark    => '100',
    jump        => 'MARK',
  }
  firewall { '110 Set MARK for GW2':
    chain       => 'INPUT',
    table       => 'mangle',
    source      => $aws_gw::outside_vpg_2,
    destination => $aws_gw::outside_cg,
    proto       => 'esp',
    set_mark    => '200',
    jump        => 'MARK',
  }

  firewall { '112 TCPMSS for Gateway':
    chain             => 'FORWARD',
    table             => 'mangle',
    proto             => tcp,
    outiface          => 'vti?',
    tcp_flags         => 'SYN,RST SYN',
    clamp_mss_to_pmtu => true,
    jump              => 'TCPMSS',
  }

}
