FactoryGirl.define do

  factory :codespace, :class => Chouette::Codespace do
    sequence(:xmlns) { |n| "Codespace xmlns #{n}" }
    sequence(:xmlnsurl) { |n| "Codespace xmlnsurl #{n}" }
  end

end

