# === Class: teleport::repo
#
# This class is meant to be called from the main class if install method is repo
# It sets variables according to platform

class teleport::repo (
    String            $release_channel            = $teleport::params::release_channel
) inherits teleport::params {

    case $facts['os']['name'] {
        'RedHat', 'OracleLinux': {

            yumrepo { 'teleport':
                baseurl  => "https://yum.releases.teleport.dev/rhel/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
                descr    => 'Gravitational Teleport packages',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => 'https://yum.releases.teleport.dev/gpg',
              }

        }
        'CentOS': {

            yumrepo { 'teleport':
                baseurl  => "https://yum.releases.teleport.dev/centos/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
                descr    => 'Gravitational Teleport packages',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => 'https://yum.releases.teleport.dev/gpg',
              }

        }
        'Rocky': {

            yumrepo { 'teleport':
                baseurl  => "https://yum.releases.teleport.dev/rocky/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
                descr    => 'Gravitational Teleport packages',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => 'https://yum.releases.teleport.dev/gpg',
              }

        }
        'Debian': {

            apt::source { "teleport":
                location => 'https://apt.releases.teleport.dev/debian',
                key      => '0C5E8BA5658E320D1B031179C87ED53A6282C411',
                repos    => "${release_channel}",
                release  => "${facts['os']['distro']['codename']}",
                include  => {
                 'src' => false,
                 'deb' => true,
                },
                notify => Class['apt::update'],
              }              

        }
        'Ubuntu': {

            apt::source { "teleport":
                location => 'https://apt.releases.teleport.dev/ubuntu',
                key      => '0C5E8BA5658E320D1B031179C87ED53A6282C411',
                repos    => "${release_channel}",
                release  => "${facts['os']['distro']['codename']}",
                include  => {
                 'src' => false,
                 'deb' => true,
                },
                notify => Class['apt::update'],
              }  

        }
        'SLES': {

            zypprepo { 'teleport':
                baseurl     => "https://zypper.releases.teleport.dev/sles/${facts['os']['release']['major']}/Teleport/${facts['os']['architecture']}/${release_channel}",
                enabled     => 1,
                autorefresh => 1,
                name        => 'Gravitational Teleport Packages',
                gpgcheck    => 1,
                gpgkey      => "https://zypper.releases.teleport.dev/gpg",
                # type        => 'rpm-md',
              }
            
              # Workaround until zypprepo allows the adding of the keys
              # https://github.com/deadpoint/puppet-zypprepo/issues/4
              exec { 'teleport_suse_import_gpg':
                command =>  "wget -q -O /tmp/teleport-GPG https://zypper.releases.teleport.dev/gpg; rpm --import /tmp/teleport-GPG; rm /tmp/teleport-GPG",
                unless  =>  "test $(rpm -qa gpg-pubkey | grep -i \"6282C411\" | wc -l) -eq 1 ",
              }

        }
        default: { fail('Unsupported OS') }
      }

}