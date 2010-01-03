ssh_options[:paranoid] = false

set :keep_releases, 3 
set :application, "playfulbent"
set :scm, :git
set :deploy_to, "/home/playful/public_html/playfulbent.com"
set :user, "playful"
set :repository, "git://github.com/craigambrose/playfulbent.git"

task :production do
  set :domain, "playfulbent.com"
  role :web, domain
  role :app, domain
  #role :email, '67.207.145.55'
  role :db,  domain, :primary => true

  set :rails_env, "production"

  set :apache_server_name, domain
  set :apache_proxy_servers, 4
end

namespace :deploy do

  task :set_permissions, :roles => [:web, :app] do  #, :email
    run "rm -rf #{release_path}/private"
    run "ln -sf #{shared_path}/private/ #{release_path}/private"
    run "ln -sf #{shared_path}/system/ #{release_path}/public/images/system"
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  # task :start_flickr_daemon, :roles => :email do
  #   sudo "monit start flickr_import"
  # end
  # 
  # task :stop_flickr_daemon, :roles => :email do
  #   sudo "monit stop flickr_import"
  # end

  # task :restart_flickr_daemon, :roles => :email do
  #   sudo "monit restart flickr_import"
  # end

  # task :restart_daemons, :roles => :email do
  #   stop_daemons
  #   start_daemons
  # end

  # task :start_daemons, :roles => :email do
  #   sudo "sh -c 'cd #{current_path} && RAILS_ENV=#{rails_env} ruby script/daemons start'", :as => mongrel_user
  # end

  # task :stop_daemons, :roles => :email do
  #   sudo "sh -c 'cd #{current_path} && RAILS_ENV=#{rails_env} ruby script/daemons stop'", :as => mongrel_user
  # end
  # 
  # task :restart_daemons, :roles => :email do
  #   stop_daemons
  #   start_daemons
  # end

  task :long do
    transaction do
      # stop_flickr_daemon
      update_code
      web.disable
      symlink
      migrate
    end

    # start_flickr_daemon
    restart_passenger

    last_minute_permissions
    web.enable
    cleanup
  end

  # task :after_deploy do
  #   restart_flickr_daemon
  #   #restart_daemons
  #   last_minute_permissions
  #   cleanup
  # end  

  # task :after_deploy_with_migrations do
  #   restart_flickr_daemon
  #   #restart_daemons
  #   last_minute_permissions
  #   cleanup
  # end

  task :restart do
    :restart_passenger
  end

  task :restart_passenger do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :last_minute_permissions do
    sudo "mkdir -p #{shared_path}/../current/tmp/attachment_fu"
    sudo "chgrp www-data #{shared_path}/../current/tmp/attachment_fu"
    sudo "chmod 775 #{shared_path}/../current/tmp/attachment_fu"
  end

  desc "changed by craig to use monit"
  task :start_mongrel_cluster , :roles => :app do
    sudo "monit start all -g #{monit_group}"
  end

  desc "changed by craig to use monit"
  task :restart_mongrel_cluster , :roles => :app do
    sudo "monit restart all -g #{monit_group}"
  end

  desc "changed by craig to use monit"
  task :stop_mongrel_cluster , :roles => :app do
    sudo "monit stop all -g #{monit_group}" 
  end

  # from Mike Clark's blog
  task :disable_web, :roles => :web do
    on_rollback { delete "#{shared_path}/system/maintenance.html" }
    maintenance = render("./app/views/layouts/maintenance.html.erb", :deadline => ENV['UNTIL'], :reason => ENV['REASON'])
    put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
  end

end

after "deploy:update_code", "deploy:set_permissions"

  # THIS STUFF NEEDS TO END UP IN playfulbent.conf
  #
  # RewriteCond %{HTTP_HOST} ^(.*).playful-bent.com$
  # RewriteRule (/.*) http://%1.playfulbent.com$1 [R=permanent,L]


  # required gems

  # rmagick
  # htmlentities
  # hpricot
  # money
  # paypal
  # daemons