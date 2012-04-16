namespace :ci do
  task :prepare do
    cp "config/database.yml.ccontrol", "config/database.yml"
  end
  task :deploy do
    cp "cp workspace.war /var/lib/tomcat6/webapps/chouette2.war"
  end
  task :build => ["db:migrate", "war", "ci:deploy"]
end

