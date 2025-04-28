# === Class: teleport::params
#
# This class is meant to be called from the main class
# It sets variables according to platform
class teleport::params {
  $version                  = '17.4.6'
  $release_channel          = 'stable/v17'
  $install_method           = 'repo' // archive or repo
  $archive_path             = '/tmp/teleport.tar.gz'
  $bin_dir                  = '/usr/local/bin'
  $assets_dir               = '/usr/local/share/teleport'
  $config_path              = '/etc/teleport.yaml'
  $nodename                 = $facts['networking']['fqdn']
  $auth_type                = 'local'
  $auth_second_factor       = 'otp'
  $auth_u2f_app_id          = 'https://localhost:3080'
  $auth_u2f_facets          = ['https://localhost:3080']
  $auth_cluster_name        = undef
  $ssh_label_commands       = [{
      name    => 'arch',
      command => '[uname, -p]',
      period  => '1h0m0s',
    },
    {
      name    => 'shortname',
      command => '[hostname, -s]',
      period  => '1h0m0s',
  }]
  $ssh_permit_user_env      = false
  $proxy_tunnel_listen_addr = '127.0.0.1'
  $proxy_tunnel_listen_port = 3024

  case $facts['os']['name'] {
    'RedHat', 'CentOS', 'Rocky', 'OracleLinux': {
      if versioncmp($facts['os']['release']['full'], '7.0') < 0 {
        fail('OS is currently not supported')
      } else {
        $init_style  = 'systemd'
        $systemd_path = '/lib/systemd/system/teleport.service'
      }
    }
    'Debian': {
      if versioncmp($facts['os']['release']['full'], '8.0') < 0 {
        fail('OS is currently not supported')
      } else {
        $init_style = 'systemd'
        $systemd_path = '/lib/systemd/system/teleport.service'
      }
    }
    'Ubuntu': {
      if versioncmp($facts['os']['release']['full'], '15.04') < 0 {
        fail('OS is currently not supported')
      } else {
        $init_style = 'systemd'
        $systemd_path = '/lib/systemd/system/teleport.service'
      }
    }
    'SLES': {
      if versioncmp($facts['os']['release']['major'], '15') < 0 {
        fail('OS is currently not supported')
      } else {
        $init_style = 'systemd'
        $systemd_path = '/usr/lib/systemd/system/teleport.service'
      }
    }
    default: { fail('Unsupported OS') }
  }
}
