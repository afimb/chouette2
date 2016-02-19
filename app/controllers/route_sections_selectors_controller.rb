class RouteSectionsSelectorsController < ChouetteController

  # singleton option makes association_chain crazy
  #defaults singleton: true

  respond_to :html, only: [ :edit, :update ]
  respond_to :js, only: :section

  belongs_to :referential do
    belongs_to :line, :parent_class => Chouette::Line do
      belongs_to :route, :parent_class => Chouette::Route do
        belongs_to :journey_pattern, parent_class: Chouette::JourneyPattern
      end
    end
  end

  def edit
    @map = RouteSectionSelectorMap.new(resource).with_helpers(self)
  end

  def update
    update!
    parent.control_route_sections
  end

  def selection
    parent

    @route_section = referential.route_sections.find params[:route_section_id].to_i
    render partial: 'selection', format: 'js'
  end

  private

  def resource
    @route_sections_selector ||= RouteSectionsSelector.new parent
  end

  def build_resource
    @route_sections_selector ||= RouteSectionsSelector.new parent, *resource_params
  end

  def route_section_selector_params
    params.require(:route_section_selector).permit()
  end

end
