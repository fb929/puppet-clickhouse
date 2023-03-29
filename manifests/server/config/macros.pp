# clickhouse::server::config::macros
#
class clickhouse::server::config::macros (
  Hash $config,
) inherits clickhouse::server {
    clickhouse::server::config { 'macros':
        section => 'config',
        data    => $config,
    }
}
