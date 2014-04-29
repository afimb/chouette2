server "chouette-int.aix.cityway.fr", :app, :web, :db, :primary => true
set :deploy_via, :copy
set :copy_cache, true
set :copy_via, :scp
set :copy_exclude, ".git/*"
set :branch, "V2_3_0"
