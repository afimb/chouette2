class AutocompleteDestinationDisplaysController < InheritedResources::Base
  respond_to :json, :only => [:index]

  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  protected

  def select_destination_displays
    referential.destination_displays
  end

  def referential_destination_displays
    @referential_destination_displays ||= select_destination_displays
  end

  def collection
    @destination_displays = referential_destination_displays.select{ |p| [p.name, p.front_text].grep(/#{params[:q]}/i).any?   }
  end
end
