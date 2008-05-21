namespace :deploy do
  namespace :logrotate do
    task :conf do
      put <<-END.gsub(/^ {8}/, ''), "#{domain_path}/etc/logrotate.conf"
        # Defaults
        create
        daily
        ifempty
        missingok
        nomail
        rotate 120
        dateext
        compress
        compresscmd /usr/bin/gzip
        sharedscripts

        # Files to rotate
        #{domain_path}/logs/mongrel.log {
        }

        #{domain_path}/logs/production.log {
        }
      END
    end

    desc 'Add a crontab entry running logrotate'
    task :crontab do
      put <<-END.gsub(/^ {8}/, ''), "#{domain_path}/tmp/crontab"
        #{capture('crontab -l').strip}
        0 0 * * * /usr/local/sbin/logrotate -s #{domain_path}/var/run/logrotate.status #{domain_path}/etc/logrotate.conf #Rotate logfiles for #{application} rails application
      END

      run <<-CMD
        crontab #{domain_path}/tmp/crontab &&
        rm #{domain_path}/tmp/crontab
      CMD
    end

    after 'deploy:setup', 'deploy:logrotate:conf'
    after 'deploy:setup', 'deploy:logrotate:crontab'
  end
end