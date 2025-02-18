# Installs yum or apt repository for ClickHouse DBMS.
#
# Uses Altinity repository for yum and yandex for apt.
#
# @summary installs repository with ClickHouse DBMS
#
# @example Simple use
#   include clickhouse::repo
#
# @author InnoGames GmbH
#
class clickhouse::repo (
    String $yumrepo_baseurl = "https://packages.clickhouse.com/rpm/lts/",
    String $yumrepo_gpgkey = "https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key",
) inherits clickhouse {
    case $facts['os']['family'] {
        'RedHat': {
            yumrepo { 'clickhouse':
                baseurl         => $yumrepo_baseurl,
                enabled         => 1,
                gpgcheck        => 0,
                gpgkey          => $yumrepo_gpgkey,
                metadata_expire => 300,
                repo_gpgcheck   => 1,
                sslverify       => 1,
                sslcacert       => '/etc/pki/tls/certs/ca-bundle.crt',
            }

            Yumrepo['clickhouse'] -> Package <| |>
        }
        'Debian': {
            apt::source { 'clickhouse_yandex':
                location => 'http://repo.yandex.ru/clickhouse/deb/stable',
                release  => 'main/',
                repos    => '',
                key      => {
                    id     => '9EBB357BC2B0876A774500C7C8F1E19FE0C56BD4',
                    server => 'hkp://keyserver.ubuntu.com:80',
                },
                include  => {
                    src => false,
                    deb => true,
                },
            }

            Apt::Source['clickhouse_yandex'] -> Package <| |>
        }
        default: {
            fail("Provides repositories only for RedHat and Debian OS families, your family is ${facts['os']['family']}")
        }
    }
}
