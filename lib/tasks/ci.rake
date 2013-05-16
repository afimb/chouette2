namespace :ci do
  task :db_travis_config do
    cp "config/database.yml.travis", "config/database.yml"
  end
  task :prepare_travis => ["ci:db_travis_config", "apartment:migrate"]
  task :db_config do
    cp "config/database.yml.ccontrol", "config/database.yml"
  end
  task :prepare => ["ci:db_config", "db:migrate"]
  task :deploy do
    cp "chouette2.war", "/var/lib/tomcat6/webapps/"
  end
  task :build => [ "war", "ci:deploy"]
end

