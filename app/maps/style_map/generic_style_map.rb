class StyleMap::GenericStyleMap
  include MapLayers
  include MapLayers::ViewHelpers

  def self.polymorphic_path_patch( source)
    
    relative_url_root = Rails.application.config.relative_url_root
    return "/assets/#{source}" unless relative_url_root
    "#{relative_url_root}/assets/#{source}"
  end
end
