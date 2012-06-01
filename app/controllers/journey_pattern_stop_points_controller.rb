class JourneyPatternStopPointsController < ChouetteController
  defaults :resource_class => Chouette::JourneyPattern

  respond_to :html

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route do
        belongs_to :journey_pattern, :parent_class => Chouette::JourneyPattern
      end
    end
  end

  def stops_selection
    redirect_to referential_line_route_journey_pattern_path( @referential, @line, @route, @journey_pattern)
  end
end

