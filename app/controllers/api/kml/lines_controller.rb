module Api
  module Kml
    class LinesController < ChouetteController
      respond_to :kml

      defaults :resource_class => Chouette::Line
      
  protected

      def collection
        @lines ||= ( @referential ? @referential.lines : [])
      end 
    end
  end
end

