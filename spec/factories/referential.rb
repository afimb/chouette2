Factory.define :referential do |f|
  f.sequence(:name) { |n| "Test #{n}" }
  f.sequence(:slug) { |n| "test_#{n}" }
end
