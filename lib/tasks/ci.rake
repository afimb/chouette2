namespace :ci do
  task :prepare do
    cp "config/database.yml.ccontrol", "config/database.yml"
  end
  task :deploy do
    cp "chouette2.war", "/var/lib/tomcat6/webapps/"
  end
  task :build => ["db:migrate", "spec", "war", "ci:deploy"]
end

