FactoryBot.define do

  factory :organisation do
    sequence(:name) { |n| "Organisation #{n}" }
  end

  factory :referential do
    sequence(:name) { |n| "Test #{n}" }
    sequence(:slug) { |n| "ch_#{n}" }
    sequence(:prefix) { |n| "test_#{n}" }
    association :organisation

    time_zone { "Europe/Paris" }
  end

  factory :rule_parameter_set do
    sequence(:name) { |n| "Test #{n}" }
    association :organisation
    after(:create) do |rsp|
      rsp.parameters = RuleParameterSet.default_for_all_modes( rsp.organisation).parameters
    end
  end

  factory :user do
    association :organisation
    sequence(:name) { |n| "chouette#{n}" }
    sequence(:email) { |n| "chouette#{n}@dryade.priv" }
    password { "secret" }
    password_confirmation { "secret" }
  end

  factory :import_task do |f|
    user_name { "dummy" }
    user_id { 123 }
    no_save { false }
    format { "Neptune" }
    resources { Rack::Test::UploadedFile.new 'spec/fixtures/neptune.zip', 'application/zip', false }
    referential { Referential.find_by_slug("ch_1") }
  end

  factory :kml_export do
    referential { Referential.find_by_slug("ch_1") }
  end

  factory :export do
    referential { Referential.find_by_slug("ch_1") }
  end

  factory :export_log_message do
    association :export
    sequence(:key) { |n| "key_#{n}" }
  end

  factory :vehicle_translation do
    count { 1 }
    duration { 1 }
  end

  factory :compliance_check_result do
    association :compliance_check_task
    rule_code { "2-NEPTUNE-StopArea-6" }
    severity { "warning" }
    status { "nok" }
  end

  factory :compliance_check_task do
    user_id { 1 }
    user_name { "Dummy" }
    status { "pending" }
    referential { Referential.find_by_slug("ch_1") }
  end

  factory :time_table_combination

end
