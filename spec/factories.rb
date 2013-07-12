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

  factory :user do |f|
    f.association :organisation
    f.sequence(:name) { |n| "chouette#{n}" }
    f.sequence(:email) { |n| "chouette#{n}@dryade.priv" }
    f.password "secret"
    f.password_confirmation "secret"
  end

  factory :import do |f|
    f.resources { Rack::Test::UploadedFile.new 'spec/fixtures/neptune.zip', 'application/zip', false }
    f.referential { Referential.find_by_slug("first") }
  end

  factory :import_log_message do |f|
    f.association :import
    f.sequence(:key) { "key_#{n}" }
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

  factory :file_validation do |f|
    f.resources { Rack::Test::UploadedFile.new 'spec/fixtures/neptune.zip', 'application/zip', false }
    f.association :organisation
  end

  factory :file_validation_log_message do |f|
    f.association :file_validation
    f.sequence(:key) { "key_#{n}" }
  end


end
