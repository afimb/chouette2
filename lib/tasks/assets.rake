namespace :assets do
  task :environment do
    # puts "Sprockets::Bootstrap workaround (#{__FILE__})"
    # Sprockets::Bootstrap.new(Rails.application).run if Rails.application.assets.paths.empty?
  end
end
