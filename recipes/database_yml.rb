require File.join(File.dirname(__FILE__), '..', 'lib', 'joyent_deployment', 'configuration_builder.rb')

namespace :deploy do
  namespace :database_yml do
    desc 'Symlink the shared database.yml into the latest_release'
    task :symlink do
      run "ln -s #{shared_path}/database.yml #{latest_release}/config/database.yml"
    end

    desc 'Write a production database.yml file into shared_path'
    task :default do
      builder = JoyentDeployment::ConfigurationBuilder.new('database.yml', fetch(:rails_env, 'production'))
      builder.gather('adapter' => 'mysql', 'database' => database, 'username' => user, 'password' => '', "socket" => '/tmp/mysql.sock')
      builder.confirm
      put builder.result.to_yaml, "#{shared_path}/database.yml", :mode => 0600
    end

    after 'deploy:setup',           'deploy:database_yml'
    after 'deploy:finalize_update', 'deploy:database_yml:symlink'
  end
end
