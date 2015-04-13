class ValidationType < ActiveEnum::Base
  value :id => 'Neptune', :name => 'Neptune'
  value :id => 'Csv', :name => 'Csv'
  value :id => 'Gtfs', :name => 'GTFS'
  value :id => 'Netex', :name => 'NeTEx'
  value :id => 'Hub', :name => 'Hub'
end
