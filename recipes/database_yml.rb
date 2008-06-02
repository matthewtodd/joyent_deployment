namespace :deploy do
  namespace :database_yml do
    desc 'Symlink the shared database.yml into the latest_release'
    task :symlink do
      run "ln -s #{shared_path}/database.yml #{latest_release}/config/database.yml"
    end

    desc 'Write a production database.yml file into shared_path'
    task :default do
      put <<-END.gsub(/^ {8}/, ''), "#{shared_path}/database.yml", :mode => 0600
        production:
          adapter:  mysql
          database: #{database}
          username: #{user}
          password: #{Capistrano::CLI.password_prompt("Enter the password for #{user} on #{database}: ")}
          socket:   /tmp/mysql.sock
      END
    end

    after 'deploy:setup',           'deploy:database_yml'
    after 'deploy:finalize_update', 'deploy:database_yml:symlink'
  end
end
