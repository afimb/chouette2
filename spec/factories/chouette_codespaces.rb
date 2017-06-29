FactoryGirl.define do

  factory :codespace, :class => Chouette::Codespace do
    sequence(:xmlns) { |n| "AB#{(64+n).chr}" }
    sequence(:xmlns_url) { |n| "http://codespace.org/xmlns_url/#{n}" }
  end

end

