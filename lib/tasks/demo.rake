namespace :demo do
  desc "restore demo account"
  task :restore  => :environment  do
    puts "A" * 40
    oo = Organisation.find_by_name("demo").destroy
    if oo
      oo.users.each &:destroy
    end

    o = Organisation.create!(:name => "demo")
    u = o.users.build( :name => "Demo", :email => "demo@chouette.mobi", :password => "chouette", :password_confirmation =>"chouette")
    u.save
    u.confirm!
    r = o.referentials.create( :name => "Tatrobus", :slug => "tatrobus", :prefix => "TAT")

    res = Rack::Test::UploadedFile.new( Rails.application.config.demo_data, 'application/zip', false)
    i = r.imports.create( :resources => res, :referential_id => r.id)
  end
end

