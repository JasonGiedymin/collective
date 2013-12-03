collective
==========

The new collective repo.

Manage vagrant/vbox clusters easily, with a quasi dedicated
chef server. Safe for bridged networks.

This app helps syncronize developers working on cluster software.


## Environment Setup

    # env
    gem install bundler

    bundle install

    # install vagrant plug-ins; yes, slightly confusing - download|install...
    rake download:plugins

    # Project deps
    rake download:gems # should just run bundle

    rake download:files # for various files needed by the app

    rake download:repos # for various repos needed by the app

    rake download:cookbooks # grabs cookbooks via berkshelf

    # !! Now you can do either a cluster or manual setup !!


## Cluster setup (recommended)

    # Cluster?
    rake vm:cluster:base:up
    
    # Upload and sync all nodes with chef
    rake vm:cluster:base:sync

    # Start the whole thing over again (destructive)?
    rake vm:cluster:base:rebirth

### What does Cluster run?

Below are manual commands which cluster will run

    # Re-provision?
    rake vm:cluster:base:provision

    # Re-bootstrap nodes?
    rake vm:cluster:base:bootstrap

    # Re-upload chef data?
    rake vm:cluster:base:upload

    # Re-Prepare node1, etc...
    rake vm:cluster:base:prepare

    # Re-Sync nodes with chef server
    rake vm:cluster:base:sync


## Manual setup

Manually boot the above with Node1 and a Chef node?

    rake vm:chef:up

    rake vm:chef:provision

    rake vm:node1:up

    rake vm:node1:provision

    rake vm:cluster:base:bootstrap

    rake vm:cluster:base:upload

    rake vm:cluster:base:sync


## Clif Notes

Remember, all the above can be easily be done via:

    rake vm:cluster:base:up


Or by doing a full rebirth which will FROM SCRATCH delete and restart
the provisioning process again (if you messed something up)

    rake vm:cluster:base:rebirth

