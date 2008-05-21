_cset(:domain) { abort "Please specify the domain you're deploying to, set :domain, 'foo'" }

server 'woodward.joyent.us', :web, :app, :user => 'matthew'

set(:deploy_to) { "/users/home/matthew/domains/#{domain}/var/www" }

set(:scm, :git)
set(:repository) { "/users/home/matthew/domains/git.matthewtodd.org/var/lib/repos/#{application}.git" }
set(:git_shallow_clone, 1)

set(:group_writable, false)
set(:use_sudo, false)
