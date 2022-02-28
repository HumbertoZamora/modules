class elasticsearch (
  $version       = 'present',
  $package_name  = 'elasticsearch',
  $service_name  = 'elasticsearch',
  $config_dir    = '/etc/elasticsearch',
  $external_repo = true,
  $base_usr      = 'https://artifacts.elastic.co/packages/8.x/yum',
  $dependencies  = ['java-1.8.0-openjdk'], #Array de dependencias.
  $cluster_name  = 'elasticsearch',
  $network_host  = 'puppet',
  $heap_size     = '2g',
)
{
  # Orden de ejecucion de
  $file_references = [ 
    File['elasticsearch.yml'],
    File['elasticsearch.sysconfig'],
  ]

  if $external_repo {
    yumrepo { 'elasticsearch':
      ensure   => present,
      baseurl  => $base_usr,
      gpgcheck => '0',
      enabled  => '1',
      before   => Package['elasticsearch'],
    }
  }

    package { $dependencies:
      ensure => installed,
      before => Package['elasticsearch'],
    }

    package { 'elasticsearch':
      ensure => $version,
      name   => $package_name,
      before => $file_references,
    }

   file { 'elasticsearch.yml':
     ensure  => file,
     path    => "${config_dir}/elasticsearch.yml",
     content => template('elasticsearch/elasticsearch.yml.erb'),
   }

   file { 'elasticsearch.sysconfig':
     ensure  => file,
     path    => '/etc/sysconfig/elasticsearch',
     content => template('elasticsearch/sysconfig.erb'),
   }

   service { 'elasticsearch':
     ensure  => running,
     name    => $service_name,
     require => $file_references, #Reinicio del servicio cuando algo cambie (elasticsearch.yml,sysconfig) y no de forma arbitraria.
   }
}
