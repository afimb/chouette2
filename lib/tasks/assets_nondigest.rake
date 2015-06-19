# https://gist.github.com/eric1234/5692456

require 'fileutils'

desc "Create nondigest versions of map assets"
task "assets:precompile" do
  fingerprint = /\-[0-9a-f]{32}\./
  for file in Dir["public/assets/{map,openlayers}/**/*"]
    next unless file =~ fingerprint
    nondigest = file.sub fingerprint, '.'
    FileUtils.cp file, nondigest, verbose: true
  end
end
