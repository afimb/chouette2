module DataFormatEnumerations
  extend Enumerize
  extend ActiveModel::Naming

  DEFAULT_FORMATS = %w(neptune gtfs netex hub)
  DEACTIVATE_FORMATS = ENV['deactivate_formats_referential'].to_s.split(',').map(&:strip)
  
  enumerize :data_format,
            in: (DEFAULT_FORMATS.select{ |format| !DEACTIVATE_FORMATS.include?(format) }),
            default: (DEFAULT_FORMATS - DEACTIVATE_FORMATS).first
end
