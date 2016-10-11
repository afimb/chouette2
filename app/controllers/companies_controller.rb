class CompaniesController < ChouetteController
  defaults :resource_class => Chouette::Company
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :js, :only => :index

  belongs_to :referential, :parent_class => Referential

  def index

    index! do |format|
      format.html {
        if collection.out_of_range? && params[:page].to_i > 1
          redirect_to url_for params.merge(:page => 1)
          return
        end
      }
      build_breadcrumb :index
    end
  end


  protected
  def collection
    @q = referential.companies.search(params[:q])
    @companies ||= @q.result(:distinct => true).order(:name).page(params[:page])
  end


  def resource_url(company = nil)
    referential_company_path(referential, company || resource)
  end

  def collection_url
    referential_companies_path(referential)
  end

  def company_params
    params.require(:company).permit( :objectid, :object_version, :creation_time, :creator_id, :name, :short_name, :organizational_unit, :operating_department_name, :code, :phone, :fax, :email, :registration_number, :url, :time_zone )
  end

end
