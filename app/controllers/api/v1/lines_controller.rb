module Api
  module V1
    class LinesController < ChouetteController
      inherit_resources

      defaults :resource_class => Chouette::Line, :finder => :find_by_objectid!
      
  protected

      def collection
        @lines ||= referential.lines
      end 
    end
  end
end


