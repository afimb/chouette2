server "chouette.cityway.fr", :app, :web, :db, :primary => true
set :copy_exclude, ".git/*"
set :branch, "V2_1_0"
ssh_options[:forward_agent] =   true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
