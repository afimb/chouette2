FactoryGirl.define do

  factory :footnote, :class => Chouette::Footnote do
    sequence(:code) { |n| "#{n}" }
    sequence(:label) { |n| "footnote #{n}" }
    association :line, :factory => :line
  end

end

