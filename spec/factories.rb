FactoryGirl.define do
  factory :company, :class => "Chouette::Company" do |company|
    company.sequence(:name) { |n| "Company #{n}" }
    company.sequence(:objectid) { |n| "test:Company:#{n}" }
    company.sequence(:registration_number) { |n| "test-#{n}" }

  end

  factory :line, :class => "Chouette::Line" do |line|
    line.sequence(:name) { |n| "Line #{n}" }
    line.sequence(:objectid) { |n| "test:Line:#{n}" }
    line.sequence(:transport_mode_name) { |n| "Bus" }

    line.association :network, :factory => :network
    line.association :company, :factory => :company

    line.sequence(:registration_number) { |n| "test-#{n}" }
  end

  factory :network, :class => "Chouette::Network" do |network|
    network.sequence(:name) { |n| "Network #{n}" }
    network.sequence(:objectid) { |n| "test:GroupOfLine:#{n}" }
    network.sequence(:registration_number) { |n| "test-#{n}" }

  end

  # factory :chouette_stop_area, :class => "Chouette::StopArea" do |f|
  #   f.latitude 10 * rand
  #   f.longitude 10 * rand
  #   f.sequence(:name) { |n| "StopArea #{n}" }
  #   f.areatype "CommercialStopPoint"
  #   f.objectid
  # end

  factory :referential do |f|
    f.sequence(:name) { |n| "Test #{n}" }
    f.sequence(:slug) { |n| "test_#{n}" }
  end

  factory :user do |f|
    f.sequence(:email) { |n| "chouette#{n}@dryade.priv" }
    f.password "secret"
    f.password_confirmation "secret"
  end

end
