Factory.define :user do |f|
  f.sequence(:email) { |n| "chouette#{n}@dryade.priv" }
  f.password "secret"
  f.password_confirmation "secret"
end
