class OrganisationsController < InheritedResources::Base
  respond_to :html

  def update
    update! do |success, failure|
      success.html { redirect_to organisation_path }
    end
  end

  private

  def resource
    @organisation = current_organisation
  end
end

