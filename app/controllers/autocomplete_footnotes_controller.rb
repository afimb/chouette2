class AutocompleteFootnotesController < InheritedResources::Base
  respond_to :json, :only => [:index]

  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  protected

  def select_footnotes
    referential.footnotes
  end

  def referential_footnotes
    @referential_footnotes ||= select_footnotes
  end

  def collection
    @footnotes = referential_footnotes.select{ |p| [p.code, p.label].grep(/#{params[:q]}/i).any?   }
  end
end
