module Chouette
  module ForBoardingEnumerations
    extend Enumerize
    extend ActiveModel::Naming

    enumerize :for_boarding, in: %w[normal forbidden request_stop is_flexible]
  end
end
