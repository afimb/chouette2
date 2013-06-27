module Api
  module Kml
    class StopAreasController < ChouetteController
      respond_to :kml

      defaults :resource_class => Chouette::StopArea

      belongs_to :referential 
      
    protected

      def collection
        @commercials = []
        @places = []
        @physicals = []
        referential.stop_areas.select {|sa| sa.longitude && sa.latitude}.each do |sa|
          case sa.area_type
          when "StopPlace"
            @places << sa
          when "CommercialStopPoint"
            @commercials << sa
          when "BoardingPosition", "Quay"
            @physicals << sa
          end
        end
      end
    end
  end
end

