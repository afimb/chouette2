namespace :ci do
  task :prepare do
    cp "config/database.yml.ccontrol", "config/database.yml"
  end
  task :build => ["ci:prepare", "spec"]
end
