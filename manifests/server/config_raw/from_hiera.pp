# clickhouse::server::config_raw::from_hiera
#
# Reads a hash from Hiera and creates clickhouse::server::config_raw resources.
#
class clickhouse::server::config_raw::from_hiera (
  Hash $configs = hiera('clickhouse::server::config_raw::configs', {}),
) {

  $configs.each |$title, $config| {
    clickhouse::server::config_raw { $title:
      content => $config['content'],
      order   => $config['order'],
      ensure  => $config.get('ensure', 'file'),
      owner   => $config.get('owner', 'clickhouse'),
      group   => $config.get('group', 'clickhouse'),
      mode    => $config.get('mode', '0644'),
    }
  }
}
