module Api
  module V1
    class LinesController < ChouetteController

      defaults :resource_class => Chouette::Line, :finder => :find_by_objectid!
      
  protected

      def collection
        @lines ||= ( @referential ? @referential.lines.search(params[:q]).result(:distinct => true) : [])
      end 
    end
  end
end


