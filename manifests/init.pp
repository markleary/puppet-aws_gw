
# Class: aws_gw
#
# This module manages an AWS customer gateway vpn using strongswan and quagga
#
# Parameters:
#
# [*package_manage*]
#   boolean toggle to overide the management of the strongswan and
#   quagga packages.
#   defaults to true

#  [*pre_shared_key_1*]
#    The Pre-Shared Key provided in the AWS VPN configuration download for
#    IPSec Tunnel #1.
#
#  [*pre_shared_key_2*]
#    The Pre-Shared Key provided in the AWS VPN configuration download for
#    IPSec Tunnel #2.
#
#  [*outside_vpg_1*]
#    The Outside IP Address provided in the AWS VPN configuration download for
#    IPSec Tunnel #1.
#
#  [*outside_vpg_2*]
#    The Outside IP Address provided in the AWS VPN configuration download for
#    IPSec Tunnel #2.
#
#  [*outside_cg*]
#    Your public facing customer gateway ip address.
#
#  [*inside_vpg_1*]
#    The inside virtual private gateway address provided in the AWS VPN
#    configuration download for IPSec Tunnel #1.
#
#  [*inside_vpg_2*]
#    The inside virtual private gateway address provided in the AWS VPN
#    configuration download for IPSec Tunnel #2.
#
#  [*inside_cg_1*]
#    The inside customer gateway address provided in the AWS VPN configuration
#    download for IPSec Tunnel #1.
#
#  [*inside_cg_2*]
#    The inside customer gateway address provided in the AWS VPN configuration
#    download for IPSec Tunnel #2.
#
#  [*local_if*]
#    The network interface bound to the local private lan.
#
#  [*quaga_pw*]
#    Quagga password.  If not defined, will use fqdn_rand_string() to generate
#    random password.
#
#  [*gateway_ip*]
#    The ip address of the local quagga router.
#
#  [*internal_lan*]
#    Your local private lan which will be routed to AWS.  Must be in cidr
#    format (e.g. 192.168.1.0/24).
#
#  [*asn_cg*]
#    The Customer Gateway ASN provided in the AWS VPN configuration download.
#
#  [*asn_vpg*]
#    The Virtual Private Gateway ASN provided in the AWS VPN configuration
#    download.
#
#  [*config_fw*]
#    If true, use Puppet Firewall module to configure mangle table.
#

class aws_gw(
  String $pre_shared_key_1,
  String $pre_shared_key_2,
  String $outside_vpg_1,
  String $outside_vpg_2,
  String $inside_vpg_1,
  String $inside_vpg_2,
  String $inside_cg_1,
  String $inside_cg_2,
  String $gateway_ip,
  String $internal_lan,
  Integer $asn_cg,
  Integer $asn_vpg,
  String $outside_cg        = $::ipaddress,
  String $private_if        = 'eth1',
  Pattern[/present|absent|installed|latest/] $package_manage = 'present',
  String $ss_service        = $aws_gw::params::ss_service,
  String $ss_package        = $aws_gw::params::ss_package,
  String $conf_path         = $aws_gw::params::conf_path,
  String $ipsec_conf_path   = $aws_gw::params::ipsec_conf_path,
  String $secrets_conf_path = $aws_gw::params::secrets_conf_path,
  String $charon_conf_path  = $aws_gw::params::charon_conf_path,
  String $zebra_conf_path   = $aws_gw::params::zebra_conf_path,
  String $bgpd_conf_path    = $aws_gw::params::bgpd_conf_path,
  String $q_package         = $aws_gw::params::q_package,
  String $zebra_service     = $aws_gw::params::zebra_service,
  String $bgpd_service      = $aws_gw::params::bgpd_service,
  String $quagga_pw         = $aws_gw::params::quagga_pw,
  Boolean $config_fw        = true,
) inherits aws_gw::params {

  anchor { 'aws_gw::begin:': }
  -> package { 'strongwan':
    ensure => $package_manage,
    name   => $ss_package,
  }
  -> package { 'quagga':
    ensure => $package_manage,
    name   => $q_package,
  }
  -> class { 'aws_gw::config': }
  -> if $config_fw { class { 'aws_gw::firewall': } }
  -> class { 'aws_gw::service': }
  -> anchor { 'aws_gw::end': }
}
