begin
  require 'warbler'
  Warbler::Task.new

  task "war:setup" do
    ENV['RAILS_RELATIVE_URL_ROOT'] ||= "/chouette2"
  end

  task :war => ["war:setup", "assets:precompile"]
rescue LoadError => e
  puts "Failed to load Warbler. Make sure it's installed."
end
