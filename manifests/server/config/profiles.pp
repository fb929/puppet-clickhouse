class clickhouse::server::config::profiles (
  Hash $data,
) inherits clickhouse::server {
  ensure_resources('clickhouse::server::config::profile', $data)
}
