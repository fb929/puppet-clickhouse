# clickhouse::server::config::base
#
class clickhouse::server::config::base (
  Hash $data,
) inherits clickhouse::server {
    clickhouse::server::config { 'base':
        section => 'config',
        data    => $data,
    }
}
