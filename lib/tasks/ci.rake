namespace :ci do
  task :prepare do
    cp "config/database.yml.ccontrol", "config/database.yml"
  end
  task :build => ["ci:prepare", "db:migrate", "spec"]
end

task :environment => "ci:prepare"
