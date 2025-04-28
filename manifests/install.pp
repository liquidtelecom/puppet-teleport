# === Class: teleport::install
#
# Installs teleport
class teleport::install {

  exec { 'dummy-teleport-notify':
    command => "/bin/true",
    refreshonly => true,  
  }

  if ( $teleport::install_method == 'archive') {
    include archive

    file { $teleport::extract_path:
      ensure => directory,
    }
    -> archive { $teleport::archive_path:
      ensure       => present,
      extract      => true,
      extract_path => $teleport::extract_path,
      source       => "https://get.gravitational.com/teleport-v${teleport::version}-linux-amd64-bin.tar.gz",
      creates      => "${teleport::extract_path}/teleport",
    }
    -> file {
      "${teleport::bin_dir}/tctl":
        ensure => link,
        target => "${teleport::extract_path}/teleport/tctl";
      "${teleport::bin_dir}/teleport":
        ensure => link,
        notify => Exec['dummy-teleport-notify'],
        target => "${teleport::extract_path}/teleport/teleport";
      "${teleport::bin_dir}/tsh":
        ensure => link,
        target => "${teleport::extract_path}/teleport/tsh";
      $teleport::assets_dir:
        ensure => link,
        target => "${teleport::extract_path}/teleport",
    }
  } else {

    require teleport::repo

    package { "teleport":
		  ensure => $teleport::version,
      notify => Exec['dummy-teleport-notify'],
	  }

    # cleanup logic for migration from archive to package
    file {
        "${teleport::bin_dir}/fdpass-teleport":
        ensure => link,
        target => "/opt/teleport/system/bin/fdpass-teleport";
      "${teleport::bin_dir}/teleport-update":
        ensure => link,
        target => "/opt/teleport/system/bin/teleport-update;
      "${teleport::bin_dir}/tbot":
        ensure => link,
        target => "/opt/teleport/system/bin/tbot;
      "${teleport::bin_dir}/tctl":
        ensure => link,
        target => "/opt/teleport/system/bin/tctl";
      "${teleport::bin_dir}/teleport":
        ensure => link,
        target => "/opt/teleport/system/bin/teleport";
      "${teleport::bin_dir}/tsh":
        ensure => link,
        target => "/opt/teleport/system/bin/tsh";
      $teleport::assets_dir:
        ensure => absent,
    }

  }
}
