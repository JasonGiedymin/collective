def getFile()
  '/opt/chef/bin/chef-solo'
end

name "role-test2"
description "test2"
run_list "recipe[apt::default]",
         "recipe[rvm::vagrant]",
         "recipe[rvm::system]"
override_attributes :node => {
  :rvm => {
    :rubies => [
      '1.9.3'
    ],
    :default_ruby => 'ruby-1.9.3',
    :user_default_ruby => 'ruby-1.9.3',
    :gems => {
      '1.9.3' => [
        { :name => 'fpm'}
      ]
    },
    :vagrant => {
      :system_chef_solo => getFile()
      :system_chef_client => '/opt/chef/bin/chef-client'
    }
  }
}