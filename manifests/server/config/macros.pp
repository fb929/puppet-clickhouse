# clickhouse::server::config::macros
#
class clickhouse::server::config::macros (
  Hash $data,
) inherits clickhouse::server {
    clickhouse::server::config { 'macros':
        section => 'config',
        data    => $data,
    }
}
