namespace :ci do
  task :prepare do
    cp "config/database.yml.ccontrol", "config/database.yml"
  end
  task :deploy do
    cp "workspace.war", "/var/lib/tomcat6/webapps/chouette2.war"
  end
  task :build => ["db:migrate", "spec", "war", "ci:deploy"]
end

