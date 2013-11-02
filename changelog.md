# Changelog

* v0.0.9 - Kickdrum
  - Add `knife_bootstrap.sh` shell proxy that can be run and not rely on vagrant
  - Add `bootstrap_nodes` node under `cluster` to list nodes that will be bootstrapped
  - Add `chef_node` node under `cluster` to specify the chef node
  - Add `vm:cluster:<name>:bootstrap` which will bootstrap nodes on a cluster
  - Add task `vm:cluster:<name>:bootstrap` to `vm:cluster:<name>:provision`, and `vm:cluster:<name>:rebirth`
  - Fix git clone issue where checkout of tag was using wrong dir location and was nested
  - Add `location` node to `repos` node
  - Fix git clone issue using fully qualifed path when cloning
  - Add roles to vagrant, configured via `core.yml` to fix #16
  - Add `roles` node to `location`
  - Modify current install of chef from deb package to cookbook, knife bootstrap still as a init
  - Modify `Vagrantfile` provisioner order to have chef first followed by shell
  - Add node nil check for roles

  - Modify order of `cluster:base` nodes
  - Modify `Vagrantfile` to use chef client to access the cluster's chef
  - Dependency on fix to chef-server cookbook [chef-server issue #34](https://github.com/opscode-cookbooks/chef-server/pull/34). Local repo with fix in case of prolonged resolution is [here on branch fix/cache_dir_missing](https://github.com/JasonGiedymin/chef-server/tree/fix/cache_dir_missing)
  - Add `chef_client` to `Vagrantfile` for nodes
  - Add `_resources` dir under `manifests/init_scripts/` for various resources
  - Add `chef_client/` dir under `_resources` for chef client pem keys
  - Add `resources` node under `locations` node in core yaml
  - Add `chef_client_keys` node under `locations` node in core yaml

* v0.0.8
  - Add `support` dir, to be used for work arounds and arch specific things on dev host
  - Add `vboxload.sh` to reload network drivers, fixes #13 (current Mavericks + vbox bug)
  - Add `location` node to `downloads`, which is a key defined in `locations`
  - Add `track` node to `downloads`, which will track the external resource
  - Add functionality to track downloads
  - Add `version` info to chef init script
  - Add `init_scripts/chef/files/.chef` resources to bootstrap chef server in cluster
  - Add global init script
  - Add SSHd config script
  - Add script to setup chef server
  - Add `node1` vm (activated via `vm:node1:up`)
  - Add `node1` vm to cluster `base` (activated via `vm:cluster:base:up`)
  - Add `init_scripts/chef/deploy_chef.sh` for deploying chef server
  - Add `init_scripts/chef/setup_chef.sh` for setting up chef server
  - Add `init_scripts/lib_functions.sh` for global functions
  - Add script to knife bootstrap `node1`

* v0.0.7
  - Add open source chef server to close #10 (using Ubuntu 12.04)
  - Add chef box
  - Add chef download
  - Add `download:files` task
  - Add `download.rb` file
  - Add `locations/init_scripts` directory location for init scripts
  - Add `locations/downloads` directory location for misc downloads
  - Add `locations/repos` directory location for repos
  - Moved repos to core.yml
  - Add init script for chef server
  - Add additional comments and terminal logging

* v0.0.6
  - Add locale to dev init
  - Add apt-get update/autoclean/remove to init
  - Add 2G to mem limit on dev box
  - Fix various commands to properly log output
  - Fix cleanup to properly clean up when doing `vm:destroy` or `vm:cleanup`
  - Fix destroy to run cleanup after (found when modifying base OS)

* v0.0.5
  - Add extra terminal logging when using raw `vm:<command>` execution paths
  - Fix version so that it reads from `core.yml`
  - Fix raw `vm:destroy` to fire and forget the command (sometimes no box can be found to be removed)

* v0.0.4
  - Fix vagrant 'randomness' issues from not nesting all calls
  - Bring back all libs
  - Add colorizing to terminal commands allowing clear status
  - Add extra terminal logging
  - Modify reboot to not provision again
  - Add sleep to allow host system eth devices to 'catch-up'

* v0.0.3
  - Add init script using inline path execution
  - Add scripts to manifest/<box>

* v0.0.2
  - Rewrite stripping out all libs

* v0.0.1
  - Rewrite with focus on clean cluster settings
