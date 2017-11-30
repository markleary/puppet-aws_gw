# Class: aws_gw::service
#
# This class configures services
class aws_gw::service inherits aws_gw {
  service { 'strongswan':
    ensure     => running,
    name       => $aws_gs::ss_service,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
  -> service { 'zebra':
    ensure     => running,
    name       => $aws_gs::zebra_service,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
  -> service { 'bgpd':
    ensure     => running,
    name       => $aws_gs::bgpd_service,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
