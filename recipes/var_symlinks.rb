namespace :deploy do
  desc 'Symlink log and pidfile directories into standard places'
  task :var_symlinks do
    run <<-CMD
      rm -rf #{domain_path}/var/log #{shared_path}/log &&
      ln -s #{domain_path}/logs #{domain_path}/var/log &&
      ln -s #{domain_path}/var/log #{shared_path}/log &&

      rm -rf #{shared_path}/pids &&
      ln -s #{domain_path}/var/run #{shared_path}/pids
    CMD
  end

  after 'deploy:setup', 'deploy:var_symlinks'
end