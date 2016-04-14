module Chouette
  module ForAlightingEnumerations
    extend Enumerize
    extend ActiveModel::Naming
    
    enumerize :for_alighting, in: %w[normal forbidden request_stop is_flexible]
  end
end
