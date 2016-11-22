FactoryGirl.define do

  factory :network, :class => Chouette::Network do
    sequence(:name) { |n| "Network #{n}" }
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }
    sequence(:registration_number) { |n| "test-#{n}" }
  end

end
