# === Class: teleport::repo
#
# This class is meant to be called from the main class if install method is repo
# It sets variables according to platform

class teleport::repo (
  String      $release_channel      = $teleport::params::release_channel
) inherits teleport::params { 

  case $facts['os']['name'] {
    'RedHat', 'OracleLinux': { 

      yumrepo { 'teleport':
        baseurl => "https://yum.releases.teleport.dev/rhel/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
        descr  => 'Gravitational Teleport packages',
        enabled => 1,
        gpgcheck => 1,
        gpgkey  => 'https://yum.releases.teleport.dev/gpg',
      }
    }
    'CentOS': { 

      yumrepo { 'teleport':
        baseurl => "https://yum.releases.teleport.dev/centos/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
        descr  => 'Gravitational Teleport packages',
        enabled => 1,
        gpgcheck => 1,
        gpgkey  => 'https://yum.releases.teleport.dev/gpg',
      }
    }
    'Rocky': { 

      yumrepo { 'teleport':
        baseurl => "https://yum.releases.teleport.dev/rocky/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
        descr  => 'Gravitational Teleport packages',
        enabled => 1,
        gpgcheck => 1,
        gpgkey  => 'https://yum.releases.teleport.dev/gpg',
       }
    }
    'Debian': { 

      apt::keyring { 'teleport-keyring.gpg':
        source => 'https://apt.releases.teleport.dev/gpg',
        dir    => '/etc/apt/trusted.gpg.d',
      }

      apt::source { "teleport":
        source_format => 'sources',
        location => ['https://apt.releases.teleport.dev/debian'],
        keyring   => '/etc/apt/trusted.gpg.d/teleport-keyring.gpg',
        repos  => ["${release_channel}"],
        release => ["${facts['os']['distro']['codename']}"],
        include => {
          'src' => false,
          'deb' => true,
        },
        notify => Class['apt::update'],
      }
    }
    'Ubuntu': {

      apt::source { "teleport":
        source_format => 'sources',
        location => 'https://apt.releases.teleport.dev/ubuntu',
        key   => {
          'name' => 'teleport-archive-keyring.asc',
          'source' => 'https://apt.releases.teleport.dev/gpg',
        },
        repos  => "${release_channel}",
        release => "${facts['os']['distro']['codename']}",
        include => {
          'src' => false,
          'deb' => true,
        },
        notify => Class['apt::update'],
      }
    }
    'SLES': { 

      zypprepo { 'teleport':
        baseurl   => "https://zypper.releases.teleport.dev/sles/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
        enabled   => 1,
        autorefresh => 1,
        name    => 'Gravitational Teleport Packages',
        gpgcheck  => 1,
        gpgkey   => "https://zypper.releases.teleport.dev/gpg",
        # type    => 'rpm-md',
      }
      # Workaround until zypprepo allows the adding of the keys
      # https://github.com/deadpoint/puppet-zypprepo/issues/4
      exec { 'teleport_suse_import_gpg':
        command => "wget -q -O /tmp/teleport-GPG https://zypper.releases.teleport.dev/gpg; rpm --import /tmp/teleport-GPG; rm /tmp/teleport-GPG",
        unless => "test $(rpm -qa gpg-pubkey | grep -i \"6282C411\" | wc -l) -eq 1 ",
      }
    }
    default: { fail('Unsupported OS') }
  }
}
