
# Class: aws_gw::params
#
# This class defines default package names
class aws_gw::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific', 'OEL', 'SLC', 'CloudLinux': {
          if (versioncmp($::operatingsystemmajrelease, '7') >= 0) {
            $ss_service        = 'strongswan'
            $ss_package        = 'strongswan'
            $ipsec_conf_path   = '/etc/strongswan/ipsec.conf'
            $secrets_conf_path = '/etc/strongswan/ipsec.secrets'
            $q_package         = 'quagga'
            $zebra_service     = 'zebra'
            $bgpd_service      = 'bgpd'

          }
        }
        default: { fail("unsupported os ${::operatingsystem}") }
      }
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }

}
