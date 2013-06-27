module Api
  module Kml
    class StopAreasController < ChouetteController
      respond_to :kml

      defaults :resource_class => Chouette::StopArea

      belongs_to :referential 
      
    protected

      def collection
        @stop_areas ||= referential.stop_areas.select {|sa| sa.longitude && sa.latitude}.select do |sa|
          case params[ :category]
          when "StopPlace"
            sa.area_type == "StopPlace"
          when "CommercialStopPoint"
            sa.area_type == "CommercialStopPoint"
          when "Physical"
            sa.area_type == "BoardingPosition" ||
              sa.area_type == "Quay"
          end
        end
      end
    end
  end
end

