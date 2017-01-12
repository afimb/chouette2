class ChouetteController < BreadcrumbController

  include ApplicationHelper
  include BreadcrumbHelper

  before_action :check_organisation
  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]
  end

  def transport_submodes
    transport_mode = params[:transport_mode]
    return {} unless transport_mode
    render json: TransportMode.submode(transport_mode, referential.data_format.to_sym)
  end

  protected

  def check_organisation
    redirect_to additionnal_fields_path unless current_organisation.present?
  end

end
