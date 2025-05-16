# clickhouse::server::config_raw
#
# Creates raw config files in /etc/clickhouse-server/config.d
#
define clickhouse::server::config_raw (
  String $content,
  Optional[String] $order = undef,
  Optional[String] $ensure = 'file',
  Optional[String] $owner = 'clickhouse',
  Optional[String] $group = 'clickhouse',
  Optional[String] $mode  = '0644',
) {

  $filename = $order ? {
    undef   => "${title}.xml",
    default => "${order}_${title}.xml"
  }

  file { "/etc/clickhouse-server/config.d/${filename}":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    notify  => Service['clickhouse-server'],
  }
}
