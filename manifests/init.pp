
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
#    The network interface bound to the private network.
#

class aws_gw(
  Pattern[/present|absent|installed|latest/] $package_manage = 'present',
  String $pre_shared_key_1                                   = undef,
  String $pre_shared_key_2                                   = undef,
  String $outside_vpg_1                                      = undef,
  String $outside_vpg_2                                      = undef,
  String $outside_cg                                         = $::ipaddress,
  String $inside_vpg_1                                       = undef,
  String $inside_vpg_2                                       = undef,
  String $inside_cg_1                                        = undef,
  String $inside_cg_2                                        = undef,
  String $private_if                                         = 'eth1',
){
  include ::aws_gw::params

  anchor { 'aws_gw::begin:': }
  -> package { 'strongwan':
    ensure => $package_manage,
    name   => $aws_gw::params::ss_package,
  }
  -> package { 'quagga':
    ensure => $package_manage,
    name   => $aws_gw::params::q_package,
  }
  -> class { 'aws_gw::config': }
  -> anchor { 'aws_gw::end': }
}
