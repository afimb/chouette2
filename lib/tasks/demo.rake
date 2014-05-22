namespace :demo do
  desc "restore demo account"
  task :restore  => :environment  do
    puts "Restore demo environment"
    old_organisation = Organisation.find_by_name("DemoChouette")
    if old_organisation
      old_organisation.users.each &:destroy
      old_organisation.destroy
    end

    organisation = Organisation.create!(:name => "DemoChouette")
    user = organisation.users.create( :name => "Demo", :email => "demo@chouette.mobi", :password => "chouette", :password_confirmation =>"chouette")
    user.confirm!
    referential = organisation.referentials.create( :name => "Tatrobus", :slug => "tatrobus", :prefix => "TAT")

    resource = Rack::Test::UploadedFile.new( Rails.application.config.demo_data, 'application/zip', false)
    import_instance = referential.import_tasks.create( :resources => resource, :referential_id => referential.id, :user_name => user.name, :no_save => false, :user_id => user.id)
    import_instance.import
    puts "Restore demo environment complete"
  end
end

