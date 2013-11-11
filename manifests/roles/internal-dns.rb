name "internal-dns"
description "Configure and install Bind to function as an internal DNS server."
override_attributes "bind" => {
  "acl-role" => "internal-acl",
  "masters" => [ "192.0.2.10", "192.0.2.11", "192.0.2.12" ],
  "ipv6_listen" => true,
  "zonetype" => "slave",
  "zonesource" => "ldap",
  "zones" => [
    "example.com",
    "example.org"
  ],
  "ldap" => {
    "server" => "example.com",
    "binddn" => "cn=chef-ldap,ou=Service Accounts,dc=example,dc=com",
    "bindpw" => "ServiceAccountPassword",
    "domainzones" => "cn=MicrosoftDNS,dc=DomainDnsZones,dc=example,dc=com"
  },
  "options" => [
    "check-names slave ignore;",
    "multi-master yes;",
    "provide-ixfr yes;",
    "recursive-clients 10000;",
    "request-ixfr yes;",
    "allow-notify { acl-dns-masters; acl-dns-slaves; };",
    "allow-query { example-lan; localhost; };",
    "allow-query-cache { example-lan; localhost; };",
    "allow-recursion { example-lan; localhost; };",
    "allow-transfer { acl-dns-masters; acl-dns-slaves; };",
    "allow-update-forwarding { any; };",
  ]
}
run_list "recipe[bind]"