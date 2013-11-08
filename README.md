collective
==========

The new collective

    # env
    gem install bundler
    bundle install

    # Project deps
    rake download:files # for various files needed by the app
    rake download:repos # for various repos needed by the app
    rake download:cookbooks # grabs cookbooks via berkshelf

    # Cluster?
    rake vm:cluster:base:up

    # Chef node?
    rake vm:chef:up

    # Node1?
    rake vm:node1:up