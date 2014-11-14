FactoryGirl.define do

  factory :organisation do |f|
    f.sequence(:name) { |n| "Organisation #{n}" }
  end

  factory :referential do |f|
    f.sequence(:name) { |n| "Test #{n}" }
    f.sequence(:slug) { |n| "test_#{n}" }
    f.sequence(:prefix) { |n| "test_#{n}" }
    f.association :organisation

    f.time_zone "Europe/Paris"
  end

  factory :rule_parameter_set do |f|
    f.sequence(:name) { |n| "Test #{n}" }
    f.association :referential
    f.after_create do |rsp|
      rsp.parameters = RuleParameterSet.default_for_all_modes( rsp.referential).parameters
    end
  end

  factory :user do |f|
    f.association :organisation
    f.sequence(:name) { |n| "chouette#{n}" }
    f.sequence(:email) { |n| "chouette#{n}@dryade.priv" }
    f.password "secret"
    f.password_confirmation "secret"
  end

  factory :import_task do |f|
    f.user_name "dummy"
    f.user_id 123
    f.no_save false
    f.format "Neptune"
    f.resources { Rack::Test::UploadedFile.new 'spec/fixtures/neptune.zip', 'application/zip', false }
    f.referential { Referential.find_by_slug("first") }
  end

  factory :kml_export do |f|
    f.referential { Referential.find_by_slug("first") }
  end

  factory :export do |f|
    f.referential { Referential.find_by_slug("first") }
  end

  factory :export_log_message do |f|
    f.association :export
    f.sequence(:key) { "key_#{n}" }
  end

  factory :vehicle_translation do |f|
    f.count 1
    f.duration 1
  end

  factory :compliance_check_result do |f|
    f.association :compliance_check_task
    f.rule_code "2-NEPTUNE-StopArea-6"
    f.severity "warning"
    f.status "nok"
  end

  factory :compliance_check_task do |f|
    f.user_id 1
    f.user_name "Dummy"
    f.status "pending"
    f.referential { Referential.find_by_slug("first") }
  end

  factory :time_table_combination 

end
