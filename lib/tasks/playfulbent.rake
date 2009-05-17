
namespace :pb do
  
  desc "Compute all tag ranks."
  task :rank_tags => [:environment] do
    last_id = 0
    while !(tags = Tag.find(:all, :limit => 20, :conditions => ["id > ?", last_id], :order => 'id ASC')).empty?
      for tag in tags
        tag.update_rank
        last_id = tag.id
      end
    end
    
    last_id = 0
    while !(ranks = TagRank.find(:all, :limit => 20, :conditions => ["id > ?", last_id], :order => 'id ASC')).empty?
      for rank in ranks
        rank.update_ratios
        last_id = rank.id
      end
    end
  end
  
  desc "Fetch Blogs"
  task :fetch_blogs => [:environment] do
    require RAILS_ROOT + '/vendor/plugins/feed_fetcher/lib/feed_fetcher/feed_fetcher.rb'
    require RAILS_ROOT + '/vendor/plugins/feed_fetcher/lib/feed_fetcher/feed_source.rb'
    
    begin
      for blog in SyndicatedBlog.find(:all)
        blog.fetch_updates
      end
    rescue Exception => exception
      NotificationsMailer.deliver_exception_report("rake task pb:fetch_blogs", exception)
      raise exception
    end
  end
  
  desc "Make local develoment site look like the live site"
  task :sync => [:environment] do
    host = 'playfulbent.com'
    path = '/var/www/apps/playfulbent/current'
    
    db_config = YAML.load_file('config/database.yml')

    system "ssh #{host} \"cd #{path} && rake db:sessions:clear\""
    system "ssh #{host} \"mysqldump -u #{db_config['production']["username"]} -p#{db_config['production']["password"] } -Q --add-drop-table -O add-locks=FALSE -O lock-tables=FALSE #{db_config['production']["database"]} > ~/dump.sql\""
    system "rsync -az --progress #{host}:~/dump.sql ./db/production_data.sql"
    system "mysql -u #{db_config['development']["username"]} -p#{db_config['development']["password"]} #{db_config['development']["database"]} < ./db/production_data.sql"
    rm_rf "./db/production_data.sql"
    # system "rsync -az --progress #{host}:#{path}/public/system/ ./public/system"
    # system "rsync -az --progress #{host}:#{path}/private/ ./private"
  end
  
  desc "Make staging site look like the live site, run this from staging server"
  task :sync_staging do
    host = 'playfulbent.com'
    path = '/var/www/apps/playfulbent/current'
    
    db_config = YAML.load_file('config/database.yml')

    system "ssh #{host} \"mysqldump -u #{db_config['production']["username"]} -p#{db_config['production']["password"] } -Q --add-drop-table -O add-locks=FALSE -O lock-tables=FALSE --ignore-table=#{db_config['production']["database"]}.sessions #{db_config['production']["database"]} > ~/dump.sql\""
    system "rsync -az --progress #{host}:~/dump.sql ./db/production_data.sql"
    system "mysql -u #{db_config['staging']["username"]} -p#{db_config['staging']["password"]} #{db_config['staging']["database"]} < ./db/production_data.sql"
    rm_rf "./db/production_data.sql"
    system "rsync -az --progress #{host}:#{path}/public/system/ ./public/system"
    system "rsync -az --progress #{host}:#{path}/private/ ./private"
  end
  
  desc "expire all open dares"
  task :expire_dares => [:environment] do
    for dare in Dare.find_open
      if dare.should_expire?
        dare.expire 
        dare.save
      end
    end    
  end
    
end

