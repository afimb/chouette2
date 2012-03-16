namespace :jekyll do
  desc "Generate help from doc/functional sources (use AUTO option to auto-regenerate)"
  task :dist do
    options = "--auto" if ENV['AUTO']
    sh "jekyll #{options} doc/functional public/help"
  end
  desc "Clean generated help"
  task :clean do
    rm_rf "public/help"
  end
end
