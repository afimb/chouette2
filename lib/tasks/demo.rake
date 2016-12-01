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
    referential = organisation.referentials.create( :name => "Tatrobus", :prefix => "TAT")

    #resource = Rack::Test::UploadedFile.new( Rails.application.config.demo_data, 'application/zip', false)
    #import_instance = ImportTask.new( :resources => resource, :referential_id => referential.id, :user_name => user.name, :no_save => false, :user_id => user.id, :name => "initialize demo", :data_format => "neptune")
    #import_instance.save
	 
	 File.open("/tmp/parameters_demo.json", "w")  { |file| 
	                                           file.write('{
"parameters" :  {
    "neptune-import": {
        "user_name" : "Demo",
        "name" : "Data restauration",
        "organisation_name" : "DemoChouette",
        "referential_name" : "Tatrobus",
        "clean_repository" : true,
        "no_save" : false
        }
	 }
}') }
	 
	 cmd = 'curl -F "file=@'+Rails.application.config.demo_data+';filename=tatrobus.zip" -F "file=@/tmp/parameters_demo.json;filename=parameters.json" http://localhost:8180/chouette_iev/referentials/'+referential.slug+'/importer/neptune'
	 system(cmd)
	 
    puts "Restore demo environment complete"
  end
end
