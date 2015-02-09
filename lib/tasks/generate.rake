namespace :generate do

  task :model_diagram do
    sh "rake erd orientation=horizontal title='Chouette v2.5.2 model diagram (part 1)' only='Organisation,Referential,Export,Api::V1::ApiKey,ExportLogMessage,ImportTask,RuleParameterSet,ComplianceCheckTask,ComplianceCheckResult,User' filename='model-diagram-part-1'"

    sh "rake erd:generate orientation=horizontal title='Chouette v2.5.2 model diagram (part 2)' exclude='Organisation,Referential,Export,Api::V1::ApiKey,ExportLogMessage,ImportTask,RuleParameterSet,ComplianceCheckTask,ComplianceCheckResult,User,NetexImport,NeptuneImport,GtfsImport,CsvImport,Delayed::Backend::ActiveRecord::Job' filename='model-diagram-part-2'"

    sh "rake erd:generate orientation=horizontal title='Chouette v2.5.2 model diagram (part 3)' only='NetexImport,NeptuneImport,GtfsImport,CsvImport,Delayed::Backend::ActiveRecord::Job' filename='model-diagram-part-3'"
  end
  
end
