# === Class: teleport
#
# Install, configures and manages teleport
#
# === Parameters
#
# [*version*]
#  Version of teleport to download
#
# [*archive_path*]
#  Where to download the teleport tarball
#
# [*extract_path*]
#  Directory to extract teleport
#
# [*bin_dir*]
#  Where to symlink teleport binaries
#
# [*assets_dir*]
#  Where to sylink the teleport web assets
#
# [*nodename*]
#  Teleport nodename.
#  Defaults to $::fqdn fact
#
# [*auth_type*]
#  default authentication type. possible values are 'local', 'oidc' and 'saml'
#  only local authentication (Teleport's own user DB) is supported in the open
#  source version
#  Defaults to 'local'
#
# [*auth_second_factor*]
#  Second_factor can be off, otp, or u2f
#  Defaults to 'otp'
#
# [*auth_u2f_app_id*]
#  app_id must point to the URL of the Teleport Web UI (proxy) accessible
#  by the end users. Only used if auth_second_factor is set to 'u2f'
#  Defaults to 'https://localhost:3080'
#
# [*auth_u2f_facets*]
#  facets must list all proxy servers if there are more than one deployed. Type array.
#  Only used if auth_second_factor is set to 'u2f'
#  Defaults to ['https://localhost:3080']
#
# [*data_dir*]
#  Teleport data directory
#  Defaults to undef (meaning teleport uses its
#  default of '/var/lib/teleport')
#
# [*ca_pin*]
#  Optional CA pin of the auth server. This enables a more secure way of
#  adding new nodes to a cluster. See "Adding Nodes to the Cluster"
#  (https://goteleport.com/docs/admin-guide/#adding-nodes-to-the-cluster).
#
# [*auth_token*]
#  The auth token to use when joining the cluster
#  Defaults to undef
#
# [*auth_cluster_name*]
#  Optional "cluster name" is needed when configuring trust between multiple
#  auth servers. A cluster name is used as part of a signature in certificates
#  generated by this CA.
#
#  By default an automatically generated GUID is used.
#
#  IMPORTANT: if you change cluster_name, it will invalidate all generated
#  certificates and keys (may need to wipe out /var/lib/teleport directory)
#  Defaults to undef
#
# [*advertise_ip*]
#  When running in NAT'd environments, designates
#  an IP for teleport to advertise.
#  Defaults to undef
#
# [*storage_backend*]
#  Which storage backend to use.
#  Defaults to undef (meaning teleport uses its
#  default of boltdb
#
# [*storage_options*]
#  Extra options for some storage backends, like DynamoDB.
#  Defaults to {}
#
# [*max_connections*]
#  Configure max connections for teleport
#  Defaults to 100
#
# [*max_users*]
#  Teleport max users
#  Defaults to 250
#
# [*log_dest*]
#  Log destination
#  Defaults to stderr (could be file)
#
# [*log_level*]
#  Log output level
#  Defaults to "ERROR"
#
# [*log_output*]
# Output format. Either json or text
# Defaults to 'text'
#
# [*log_extra_fields*]
# possible fields: timestamp, component, caller and level
# Defaults to all
#
# [*cluster_name*]
# A cluster name is used as part of a signature in certificates
# generated by this CA.
#
# We strongly recommend explicitly setting it to something meaningful as it
# becomes important when configuring trust between multiple clusters.
#
# By default an automatically generated name is used (not recommended)
#
# IMPORTANT: if you change cluster_name, it will invalidate all generated
# certificates and keys (may need to wipe out /var/lib/teleport directory)
#
# [*proxy_protocol*]
# ProxyProtocol enables support for HAProxy proxy protocol version 1 when it is turned 'on'.
# Verify whether the service is in front of a trusted load balancer.
# The default value is 'on'.
#
# [*config_path*]
#  Path to config file for teleport
#  Defaults to /etc/teleport.yaml
#
# [*auth_server*]
#  An auth server to connect to
#  Define this OR proxy_server but not both
#
# [*proxy_server*]
#  An auth server to connect to
#  Define this OR auth_server but not both
#
# [*auth_enable*]
#  Whether to start the auth service
#  Defaults to false
#
# [*auth_listen_addr*]
#  Address to listen for auth_service
#
# [*auth_public_addr*]
# The optional DNS name for the auth server if located behind a load
# balancer.
#
# [*auth_public_port*]
# Public port to auth server
#
# [*auth_listen_port*]
#  Port to listen on for auth server
#
# [*auth_service_tokens*]
#  The provisioning tokens for the auth tokens
#  Defaults to an empty array
#
# [*  enable*]
#  Whether to start SSH service
#  Defaults to true
#
# [*ssh_listen_addr*]
#  Address to listen on for SSH connections
#  Defaults to 0.0.0.0
#
# [*ssh_listen_port*]
#  Port to listen on for SSH connection
#
# [*ssh_public_addr*]
#  Address to listen on for SSH connections
#  Defaults to 0.0.0.0
#
# [*ssh_public_port*]
#  Port to listen on for SSH connection
#
# [*labels*]
#  A hash of labels to assign to hosts
#
# [*ssh_label_commands*]
#  List of the commands to periodically execute. Their output will be used as node labels.
#  See "Labeling Nodes" section below for more information.
#  Defaults to [{
#    name    => 'arch',
#    command => '[uname, -p]',
#    period  => '1h0m0s',
#  }]
#
# [*ssh_permit_user_env*]
#  enables reading ~/.tsh/environment before creating a session. by default
#  set to false, can be set true here or as a command line flag.
#  Defaults to false
#
# [*proxy_enable*]
#  Where to start the proxy service
#  Defaults to false
#
# [*proxy_listen_addr*]
#  Address to listen on for proxy
#
# [*proxy_listen_port*]
#  Port to listen on for proxy connection
#
# [*proxy_public_addr*]
# The DNS name of the proxy HTTPS endpoint as accessible by cluster users.
# Defaults to the proxy's hostname if not specified. If running multiple
# proxies behind a load balancer, this name must point to the load balancer
# If application access is enabled, public_addr is used to write correct
# redirects
# (https://goteleport.com/docs/application-access/guides/connecting-apps/#start-authproxy-service).
# If database access is enabled, Database clients will connect to the Proxy
# over this hostname
# (https://goteleport.com/docs/database-access/architecture/#database-client-to-proxy).
#
# [*proxy_public_port*]
#  Port to listen on for proxy public dns
#
# [*proxy_tunnel_listen_addr*]
#  Reverse tunnel listening address. An auth server (CA) can establish an
#  outbound (from behind the firewall) connection to this address.
#  This will allow users of the outside CA to connect to behind-the-firewall
#  nodes.
#  Defaults to '127.0.0.1'
#
# [*proxy_tunnel_listen_port*]
#  Reverse tunnel listening port.
#  Defaults to 3024
#
# [*proxy_tunnel_public_addr*]
# The DNS name of the tunnel SSH endpoint as accessible by trusted clusters
# and nodes joining the cluster via Teleport IoT/node tunneling.
# Defaults to the proxy's hostname if not specified. If running multiple
# proxies behind a load balancer, this name must point to the load
# balancer. Use a TCP load balancer because this port uses SSH protocol.
#
# [*proxy_tunnel_public_port*]
#  Reverse tunnel public port.
#  Defaults to 3024
#
# [*proxy_ssh_public_addr*]
# The DNS name of the proxy SSH endpoint as accessible by cluster clients.
# Defaults to the proxy's hostname if not specified. If running multiple
# proxies behind a load balancer, this name must point to the load
# balancer.
# Use a TCP load balancer because this port uses SSH protocol.
#
# [*proxy_ssh_public_port*]
# Defaults 3023
#
# [*proxy_web_listen_addr*]
#  Address to listen on for web proxy
#
# [*proxy_web_listen_port*]
#  Port to listen on for web proxy connections
#
# [*proxy_kube_listen_addr*]
# Kubernetes proxy listen address.
#
# If not set, behavior depends on the config file version:
#
# "v2": listener is not created, Kubernetes traffic is multiplexed on web_listen_addr
# "v1": defaults to 0.0.0.0:3026
# [*proxy_kube_listen_port*]
#  Kube listening port.
#  Defaults to 3026
#
# [*proxy_kube_public_addr*]
# Optional: set a different public address for kubernetes access
#
# [*proxy_kube_public_port*]
# Reverse kube public port.
# Defaults to 3026
#
# [*proxy_mysql_listen_addr*]
# MySQL proxy listen address.
#
# If not set, behavior depends on the config file version:
#
# "v2": listener is not created, MySQL traffic is multiplexed on
#       web_listen_addr
# "v1": defaults to 0.0.0.0:3036
#
# [*proxy_mysql_listen_port*]
#  mysql listening port.
#  Defaults to 3036
#
# [*proxy_mysql_public_addr*]
# Address advertised to MySQL clients. If not set, public_addr is used.
#
# [*proxy_mysql_public_port*]
# Reverse mysql public port.
# Defaults to 3036
#
# [*proxy_postgres_listen_addr*]
# Postgres Proxy listener address. If provided, proxy will use a separate
# listener
# instead of multiplexing Postgres protocol on web_listener_addr.
#
# [*proxy_postgres_listen_port*]
#  postgres listening port.
#  Defaults to 5432
#
# [*proxy_postgres_public_addr*]
# Address advertised to postgres clients. If not set, public_addr is used.
#
# [*proxy_postgres_public_port*]
# Reverse postgres public port.
# Defaults to 5432
#
# [*proxy_mongo_listen_addr*]
# mongo Proxy listener address. If provided, proxy will use a separate
# listener
# instead of multiplexing mongo protocol on web_listener_addr.
#
# [*proxy_mongo_listen_port*]
#  mongo listening port.
#  Defaults to 27017
#
# [*proxy_mongo_public_addr*]
# Address advertised to mongo clients. If not set, public_addr is used.
#
# [*proxy_mongo_public_port*]
# Reverse mongo public port.
# Defaults to 27017
#
# [*proxy_ssl*]
#  Enable or disable SSL support
#  Default is false
#
# [*proxy_ssl_files*]
#  Path to SSL keys and certs for proxy. Declared as an dict of arrays
# [
#  { 
#   key: '/var/lib/teleport/webproxy_key.pem',
#   cert: '/var/lib/teleport/webproxy_cert.pem',
#  },
#  { 
#   key: '/etc/letsencrypt/live/example.com/example2_key.pem',
#   cert: '/etc/letsencrypt/live/example.com/example2_cert.pem',
#  },
# ]
# [*app_enable*]
# Enable or disable app_service
# Default is false
#
# [*app_debug*]
# Enable or disable app_service debug
# Default is false
#
# [*app_apps*]
# Nested Array and Hash with apps (only works if app_enable is true)
# Be careful with the data structure, as it MUST follow correctly
# (https://goteleport.com/docs/application-access/reference/#configuration)
# In this example we have 2 apps with different set of params.
# You can see that no all params are obrigatory:
# [ 
#  { 
#   name => "my_app",
#   uri => 'http://127.0.0.1:8000',
#   public_addr => 'myapp.domain.com',
#   labels => {
#             'label1': 'content_of_mylabel01',
#             'label2': 'content_of_mylabel02',
#             },
#   },
#  { 
#   name => "shablau-app-dash",
#   uri => 'http://8.8.8.8:1235',
#   commands => [
#               {
#                 name => "os"
#                 command: ["/usr/bin/uname"]
#                 period: "5s"
#               },
#               ]
#  },
# ]
#
# [*init_style*]
#  Which init system to use to start the service. Currently only
#  systemd is supported
#
# [*manage_service*]
#  Whether puppet should manage and configure the service
#
# [*service_ensure*]
#  State of the teleport service
#
# [*service_enable*]
#  Whether the service should be enabled on startup
#
class teleport (
  String            $version                    = $teleport::params::version,
  String            $archive_path               = $teleport::params::archive_path,
  String            $extract_path               = "/opt/teleport-${version}",
  String            $bin_dir                    = $teleport::params::bin_dir,
  String            $assets_dir                 = $teleport::params::assets_dir,
  String            $nodename                   = $teleport::params::nodename,
  String            $auth_type                  = $teleport::params::auth_type,
  String            $auth_second_factor         = $teleport::params::auth_second_factor,
  String            $auth_u2f_app_id            = $teleport::params::auth_u2f_app_id,
  Array             $auth_u2f_facets            = $teleport::params::auth_u2f_facets,
  Optional[String]  $auth_cluster_name          = $teleport::params::auth_cluster_name,
  Optional[String]  $data_dir                   = undef,
  Optional[String]  $ca_pin                     = undef,
  Optional[String]  $auth_token                 = undef,
  Optional[String]  $advertise_ip               = undef,
  Optional[String]  $storage_backend            = undef,
  Hash              $storage_options            = {},
  Integer           $max_connections            = 1000,
  Integer           $max_users                  = 250,
  String            $log_dest                   = 'stderr',
  String            $log_level                  = 'ERROR',
  String            $log_output                 = 'text',
  Array             $log_extra_fields           = ['level', 'timestamp', 'component', 'caller'],
  String            $config_path                = $teleport::params::config_path,
  Optional[String]  $cluster_name               = undef,
  String            $proxy_protocol             = 'on',
  Optional[String]  $auth_server                = undef,
  Optional[String]  $proxy_server               = '127.0.0.1:443',
  Boolean           $auth_enable                = false,
  String            $auth_listen_addr           = '127.0.0.1',
  Integer           $auth_listen_port           = 3025,
  Optional[String]  $auth_public_addr           = undef,
  Optional[Integer] $auth_public_port           = undef,
  Array             $auth_service_tokens        = [],
  Boolean           $ssh_enable                 = true,
  String            $ssh_listen_addr            = '0.0.0.0',
  Integer           $ssh_listen_port            = 3022,
  Optional[String]  $ssh_public_addr            = undef,
  Optional[Integer] $ssh_public_port            = undef,
  Hash              $labels                     = {},
  Array             $ssh_label_commands         = $teleport::params::ssh_label_commands,
  Boolean           $ssh_permit_user_env        = $teleport::params::ssh_permit_user_env,
  Boolean           $proxy_enable               = false,
  String            $proxy_listen_addr          = '127.0.0.1',
  Integer           $proxy_listen_port          = 3023,
  Optional[String]  $proxy_public_addr          = undef,
  Optional[Integer] $proxy_public_port          = undef,
  String            $proxy_tunnel_listen_addr   = $teleport::params::proxy_tunnel_listen_addr,
  Integer           $proxy_tunnel_listen_port   = $teleport::params::proxy_tunnel_listen_port,
  Optional[String]  $proxy_tunnel_public_addr   = undef,
  Optional[Integer] $proxy_tunnel_public_port   = undef,
  Optional[String]  $proxy_ssh_public_addr      = undef,
  Optional[Integer] $proxy_ssh_public_port      = undef,
  String            $proxy_web_listen_addr      = '127.0.0.1',
  Integer           $proxy_web_listen_port      = 3080,
  Boolean           $proxy_ssl                  = false,
  Hash              $proxy_ssl_files            = {},
  Optional[String]  $proxy_kube_listen_addr     = undef,
  Optional[Integer] $proxy_kube_listen_port     = undef,
  Optional[String]  $proxy_kube_public_addr     = undef,
  Optional[Integer] $proxy_kube_public_port     = undef,
  Optional[String]  $proxy_mysql_listen_addr    = undef,
  Optional[Integer] $proxy_mysql_listen_port    = undef,
  Optional[String]  $proxy_mysql_public_addr    = undef,
  Optional[Integer] $proxy_mysql_public_port    = undef,
  Optional[String]  $proxy_postgres_listen_addr = undef,
  Optional[Integer] $proxy_postgres_listen_port = undef,
  Optional[String]  $proxy_postgres_public_addr = undef,
  Optional[Integer] $proxy_postgres_public_port = undef,
  Optional[String]  $proxy_mongo_listen_addr    = undef,
  Optional[Integer] $proxy_mongo_listen_port    = undef,
  Optional[String]  $proxy_mongo_public_addr    = undef,
  Optional[Integer] $proxy_mongo_public_port    = undef,
  Boolean           $app_enable                 = false,
  Boolean           $app_debug                  = false,
  Array             $app_apps                   = [],
  String            $init_style                 = $teleport::params::init_style,
  Boolean           $manage_service             = true,
  String            $service_ensure             = 'running',
  Boolean           $service_enable             = true
) inherits teleport::params {
  validate_legacy(Array, 'validate_array', $ssh_label_commands)
  validate_legacy(Array, 'validate_array', $auth_u2f_facets)
  validate_legacy(Hash, 'validate_hash', $storage_options)
  validate_legacy(Boolean, 'validate_bool', $auth_enable)
  validate_legacy(Boolean, 'validate_bool', $ssh_permit_user_env)
  validate_legacy(Boolean, 'validate_bool', $ssh_enable)
  validate_legacy(Hash, 'validate_hash', $labels)
  validate_legacy(Boolean, 'validate_bool', $proxy_enable)
  validate_legacy(Boolean, 'validate_bool', $proxy_ssl)
  validate_legacy(Boolean, 'validate_bool', $manage_service)
  validate_legacy('Optional[String]', 'validate_re', $service_ensure, '^(running|stopped)$')
  validate_legacy(Boolean, 'validate_bool', $service_enable)
  validate_legacy(Array, 'validate_array', $auth_service_tokens)
  validate_legacy(Array, 'validate_array', $log_extra_fields)

  anchor { 'teleport_first': }
  -> class { 'teleport::install': }
  -> class { 'teleport::config': }
  -> class { 'teleport::service': }
  -> anchor { 'teleport_final': }
}
