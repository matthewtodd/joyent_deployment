require 'active_support'

namespace :deploy do
  namespace :secret_txt do
    desc 'Write a production secret.txt file into shared_path'
    task :default do
      put ActiveSupport::SecureRandom.hex(64), "#{shared_path}/secret.txt", :mode => 0600
    end

    desc 'Symlink the shared secret.txt into the latest_release'
    task :symlink do
      run "ln -s #{shared_path}/secret.txt #{latest_release}/config/secret.txt"
    end
  end
end

after 'deploy:setup',           'deploy:secret_txt'
after 'deploy:finalize_update', 'deploy:secret_txt:symlink'
