# Changelog


## Todo
  * Hostname fails when using 13.04. Need to add 'dev.localdomain' entry in `/etc/hosts` file
  * need to make sure export of mesos is /usr/local rather than /usr/local/bin
  - add direct support for vagrant host
    - add default domain, and option to specify manual
      defaults:
        - domain: example.com
      - node:
          fqdn: somehost.example.com
          # OR
          fqdn: ~ # empty entry, falls back on domain default (<name>.domain)
  - SEE => https://github.com/everpeace/vagrant-mesos
  - https://github.com/adrienthebo/vagrant-hosts
  - https://github.com/fgrehm/vagrant-cachier
  - PhantomJS
  - Jasmine
  - Guard::Jasmine
  - Shipyard


* v0.0.14 - "Shadow"
  - Update documentation
  - Add beginning of mesos-docker work
  - Remove legacy repos/cookbooks
  - Add user `vagrant.d` box removal during `:cleanup`
  - Add local `.vagrant` box removal during `:cleanup`
  - Fix UI setting that allows vbox GUI to be shown
  - Add `precise32` and `precise64` images from vagrantup (thus far the best images around)
  - Add `vm:<name>:export` command that will vagrant export boxes
  - Add `download:plugins` which will download and _install_ vagrant plugins (yeah seems confusing), will have to change this in the future.
  - Add omnibus `:latest` definition to download latest chef
  - Modify runlist in dev box to specify OracleJDK specific recipe
  - Add reference docker boxes, see this [link](http://blog.phusion.nl/2013/11/08/docker-friendly-vagrant-boxes/)
  - Add `growl` since long running jobs are so... long running
  - Add direct support for `vagrant-cachier`, with autodetect and caching of `apt`, `npm`, `chef`, `gem`, and `rvm`
  - Add `mesos` and `mesos-docker` to dev box via install script (do not use cookbook just yet). Install script can install from source if using the docker reference box, or via mesosphere script when using Ubuntu 13.04.
  - Add expanded usage of growl notifications, allowing for warn, info, error, and success levels of messages
  - Add debug level to `core.yml`, and add debug message function
  - Add `vm:<name>:nuke` command to Nuke a vm which will clean up all vagrant related files
  - Add `cluster:<name>:nuke` command to run `nuke` for an entire cluster


* v0.0.13 - "Starfleet Academy"
  - Modify vagrant chef logging mode to debug
  - Remove legacy `roles` dir
  - Add `manifests/init_scripts/lib`, can start moving scripts there now
  - Add `run_docker_registry.sh` script that will safely determine if it should bootstrap
    a new `docker-registry` by checking if it is already running
  - Add `docker` recipe to `chefzero` role, and bootstrap `docker-registry` on
    chefzero nodes (specifically `10.10.10.10`). You may need to run
    `vm:cluster:<name>:provision` if you've ran `up` on a cluster that was
    already created and was only cycled. Fixes #24.
  - Start of work dealing with 'unmanaged' clusters, however this feature is deferred ftm.

  Notes:
    * docker-registry cookbook is busted. I'm not confident chef should be the
    tool to deploy dockers especially as it goes against many of the tooling
    it is built around (ohai, libs, etc...).


* v0.0.12 - "Captain"
  - Add `role-dev-node` to bootstrap dev nodes
  - Add the following cookbooks: `lxc`, `docker`, `etcd`, `nodejs`, `golang`, `python`
  - Add manual bash script to install docker, however this is not recommended. Use the recipe instead, like the `role-dev-node`.
  - Modify `dev` box to have 1024MB of ram
  - Modify `dev` box to have 2 CPUs
  - Modify `role-runtimes` to include `recipe[rvm::vagrant]` to help vagrant work with rvm


* v0.0.11 - "Tree Frog"
  - Modify `chef-client` during `sync` ~~to start in daemon mode~~ (_daemon mode has a memory leak, verified via my mem profiling, it will eventually crash the system; notes added_)
  - Swap `prepare` with `sync` in the `vm:cluster` namespace
  - Fix issue with `vm:cluster:<name>:up` that accidently called `vm:<node>:prepare` instead of `vm:cluster:<name>:prepare`. Also call `prepare` after nodes are up.
  - Modify `vm:cluster:reboot` so that each `vm:<node>:reboot` will be forced provisioned again
  - Start of componentizing
  - Integrated local roles into chef-server roles to dog food role specs
  - Add `sync` to `vm:cluster:<name>:reboot`
  - Add `sync` to `vm:cluster:<name>:rebirth`


* v0.0.10 - Hummingbird
  - Update `README`
  - Add new node `DNS`
    - installs `bind` cookbook onto node `DNS`
  - Add `manage_chef.sh` to handle `knife` cookbook install and uploads
  - Add reference to cookbook repository [collective-cookbooks](https://github.com/JasonGiedymin/collective-cookbooks) which is used to install on the server
  - Modified chef server repo location `repo/` to `manifests/repos/collective-cookbooks/`
  - Add `Berkshelf` to `Gemfile`
  - Add `Berksfile` under `manifests/berkshelf/`
  - Add `berks-config` under `manifests/berkshelf/`
  - Move `collective-cookbooks` to `manifests/berkshelf/cookbooks`
  - Add `java`, `scala`, `rvm` to `Berksfile`
  - Add `rvm` attribs to `chef-server` role
  - Add console color to `System.shell_cmd`
  - Add ubuntu 13 box to downloads (tbd, seems to fail alot)
  - Add commands to manage chef server via berkshelf
  - Modify `download:cookbooks` to always delete `Berksfile.lock` as well as the `manifests/berkshelf/cookbooks` directory
  - Modify `berkshelf` location node to reference berkshelf root
  - Modify `setup_chef.sh` to be `:provision` friendly and only bootstrap knife admin on a clean server
  - Rename `dev` box to `devstack` to be more clear what it is used for
  - Add `dev` box which will be pure dev box, not tied to anything (including any [IP]aaS)
  - Add `desc` node to each box for light reading
  - Add `apt` to Berkshelf (it is pulled as a dependency but I want it as a hard dependency)
  - Add new role: `roles-runtimes` that will be a base runtime role for most nodes
  - Add `update:all` rake task to update all files, similar to `install:auto` of old.
  - Add `fog` and `knife-server`, hopefully someday it will actually work
  - Add `400`s timeout directive to vagrant ssh
  - Add `chef-zero`
  - Move `berkshelf` under `chef-server` which will serve as a base for chef server data
  - Add `vm:cluster:<name>:upload` which will upload data to the chef server
  - Add `vm:cluster:<name>:sync` which will sync the node to the chef server
  - Add `vm:cluster:<name>:prepare` which will bootstrap, upload, and then sync the cluster


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
  - Modify role `chef-server` so that it relies on deb package rather than get from omnibus repo, to save bandwidth
  - ~~Add vagrant `chef_client` to bootstrap nodes~~
  - Deprecate vagrant `chef_client` and instead use knife bootstrap via `vm:cluster:<name>:bootstrap`
  - Add `_resources` dir under `manifests/init_scripts/` for various resources
  - Add `chef_client/` dir under `_resources` for chef client pem keys
  - Add `resources` node under `locations` node in core yaml
  - Add `chef_client_keys` node under `locations` node in core yaml
  - Add `manage_chef.sh` to manage knife and the chef server

  Note: This version has been tested to run `rake vm:cluster:base:rebirth` with success, and that includes running the cluster bootstrap command.


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

