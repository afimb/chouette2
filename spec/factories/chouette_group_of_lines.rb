FactoryGirl.define do

  factory  :group_of_line, :class => Chouette::GroupOfLine do
    sequence(:name) { |n| "Group Of Line #{n}" }
    sequence(:objectid) { |n| "objectid_#{n}" }
    sequence(:codespace) { |n| "codespace_#{n}" }
    sequence(:registration_number) { |n| "#{n}" }
  end

end
