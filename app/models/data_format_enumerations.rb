module DataFormatEnumerations
  extend Enumerize
  extend ActiveModel::Naming
  
  enumerize :data_format, in: ([:neptune, :netex, :gtfs, (ENV['deactivate_hub'] ? '' : :hub)].reject(&:blank?)), default: "neptune"
end
