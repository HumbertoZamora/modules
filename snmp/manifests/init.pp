
class snmp {

  Package['snmp'] -> File['snmpd.conf'] ~> Service['snmp']

  $package    = 'net-snmp'
  $configfile = '/etc/snmp/snmpd.conf'
  $service    = 'snmpd'

  package { 'snmp':
    ensure => installed,
    name   => "${package}",
  }

# Agregar la linea: content => template('snmp/snmpd.conf'), hace que puppet busque en la carpeta: template.
  file { 'snmpd.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0444',
    content => template('snmp/snmpd.conf.erb'),
    path    => "${configfile}",
  }

  service { 'snmp':
    ensure => running,
    name   => "${service}",
  }

}
