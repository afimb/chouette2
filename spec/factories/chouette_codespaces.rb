FactoryGirl.define do

  factory :codespace, :class => Chouette::Codespace do
    sequence(:xmlns) { |n| "Codespace xmlns #{n}" }
    sequence(:xmlns_url) { |n| "Codespace xmlnsurl #{n}" }
  end

end

