
class snmp (
  $package    = 'net-snmp',
  $service    = 'snmpd',
  $configfile = '/etc/snmp/snmpd.conf',
  $community  = 'puppet',
  $syscontact = 'Humberto Zamora <humber_zam@yahoo.com.mx>',
  $server     = '127.0.0.1',
)
{
# El caracter ~> (~) hace que el servicio se reinicie.
  Class['snmp::install'] -> Class['snmp::config'] ~> Class['snmp::service']

  include snmp::params
  include snmp::install
  include snmp::config
  include snmp::service
}
