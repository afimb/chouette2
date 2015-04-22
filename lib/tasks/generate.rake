namespace :generate do
  
  desc "Create model diagrams for Chouette"
  task :model_diagram  => :environment do
    sh "bundle exec rake erd orientation=horizontal title='Chouette v2.5.2 model diagram (part 1)' only='Organisation,Referential,Export,Api::V1::ApiKey,ExportLogMessage,Import,RuleParameterSet,Validation,User' filename='model-diagram-part-1'"

    sh "bundle exec rake erd:generate orientation=horizontal title='Chouette v2.5.2 model diagram (part 2)' exclude='Organisation,Referential,Export,Api::V1::ApiKey,ExportLogMessage,Import,RuleParameterSet, Validation,User,NetexImport,NeptuneImport,GtfsImport,CsvImport,Delayed::Backend::ActiveRecord::Job' filename='model-diagram-part-2'"

    sh "bundle exec rake erd:generate orientation=horizontal title='Chouette v2.5.2 model diagram (part 3)' only='NetexImport,NeptuneImport,GtfsImport,CsvImport,Delayed::Backend::ActiveRecord::Job' filename='model-diagram-part-3'"
  end
  
end
