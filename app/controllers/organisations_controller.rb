class OrganisationsController < InheritedResources::Base
  respond_to :html

  private

  def resource
    @organisation = current_organisation
  end
end

