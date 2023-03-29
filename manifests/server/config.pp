# This type creates custom configuration files for clickhouse-server.
#
# @summary generates xml config from hash via ruby xml-simple
#
# @param data
#   This hash will be converted into xml config placed in `$clickhouse::server::config_d_dir`.
#
#   Root will be `<yandex>` by default.
# @param section
#   Should the file be created in configs or users include directory.
# @param ensure
#   Subset of attribute `ensure` for `file` type.
# @param mode
#   Desired permissions mode for the config file, see `mode` attribute for `file` resource.
# @param service_notify
#   If service should be restarted on the config changing.
#
# @example Usage
#   clickhouse::server::config { 'macros':
#     data    => {'macros' => [
#         {'hostname' => ['host.domain.TLD'],}
#     ]},
#     section => 'config',
#   }
#   #
#   # Will create file `/etc/clickhouse-server/conf.d/macros.xml`:
#   # <yandex>
#   #   <macros>
#   #     <hostname>host.domain.TLD</hostname>
#   #   </macros>
#   # </yandex>
#
# @author InnoGames GmbH
#
define clickhouse::server::config (
    Hash                    $data,
    Enum['config', 'users'] $section,
    Enum[
        'present',
        'file',
        'absent'
    ]                       $ensure         = 'present',
    String[1]               $mode           = '0644',
    Boolean                 $service_notify = false,
) {

    include clickhouse::server

    with($section ? {
        'config' => "${clickhouse::server::config_d_dir}/${title}.xml",
        'users'  => "${clickhouse::server::users_d_dir}/${title}.xml",
        default  => error("Attribute \$section is wrong (== ${section}), see the definition"),
    }) |$config_path| {
        file { $config_path:
            ensure  => $ensure,
            content => hash2xml("yandex", $data),
            mode    => $mode,
            owner   => $clickhouse::user,
            group   => $clickhouse::group,
            require => Package[$clickhouse::server::package_name],
            before  => Service[$clickhouse::server::service_name],
        }

        if ($service_notify) {
            File[$config_path] ~> Service[$clickhouse::server::service_name]
        }
    }
}
