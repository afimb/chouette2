class ImportType < ActiveEnum::Base
  value :id => 'Neptune', :name => 'Neptune'
  value :id => 'Csv', :name => 'Csv'
  value :id => 'Gtfs', :name => 'GTFS'
  value :id => 'Netex', :name => 'NeTEx'
end
