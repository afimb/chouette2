FactoryBot.define do
  
  factory :access_link, :class => Chouette::AccessLink do
    sequence(:name) { |n| "Access link #{n}" }
    sequence(:objectid) { |n| "test:AccessLink:#{n}" }
    link_type { "Mixed" } 
    link_orientation { "AccessPointToStopArea" }

    association :stop_area, :factory => :stop_area
    association :access_point, :factory => :access_point
  end

end
