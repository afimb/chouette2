namespace :ci do
  task :db_travis_config do
    cp "config/database.yml.travis", "config/database.yml"
  end
  
  task :deploy do
    cp "chouette2.war", "/var/lib/tomcat6/webapps/"
  end  
  task :build => [ "war", "ci:deploy"]
end

