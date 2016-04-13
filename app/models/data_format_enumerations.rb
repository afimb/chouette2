module DataFormatEnumerations
  extend Enumerize
  extend ActiveModel::Naming
  
  enumerize :data_format, in: (%w(neptune netex gtfs hub).select{ |format|
    !ENV['deactivate_formats_referential'].to_s.split(',').map(&:strip).include?(format)
  })
end
