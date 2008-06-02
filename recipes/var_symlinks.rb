namespace :deploy do
  namespace :var_symlinks do
    desc 'Symlink log and pidfile directories into standard places'
    task :default do
      run <<-CMD
        ln -s #{domain_path}/logs #{domain_path}/var/log &&
        ln -s #{domain_path}/var/log #{shared_path}/log &&
        ln -s #{domain_path}/var/run #{shared_path}/pids
      CMD
    end

    task :prepare do
      run <<-CMD
        rm -rf #{domain_path}/var/log &&
        rm -rf #{shared_path}/log &&
        rm -rf #{shared_path}/pids
      CMD
    end
  end

  # We have to delete the symlinks so mkdir -p will work if we run deploy:setup again.
  before 'deploy:setup', 'deploy:var_symlinks:prepare'
  after 'deploy:setup', 'deploy:var_symlinks:prepare'
  after 'deploy:setup', 'deploy:var_symlinks'
end