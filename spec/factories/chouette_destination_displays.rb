FactoryBot.define do
  factory :destination_display, :class => Chouette::DestinationDisplay do
    sequence(:name) { |n| "DestinationDisplay name #{n}" }
    sequence(:front_text) { |n| "DestinationDisplay front_text #{n}" }
    sequence(:side_text) { |n| "DestinationDisplay side_text #{n}" }
  end
end

