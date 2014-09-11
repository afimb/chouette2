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
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end
      add_breadcrumb Referential.model_name.human(:count => 2), referentials_path()
      add_breadcrumb @referential.name, referential_path(@referential)
      }
    end       
  end
  
  def show
    show! do
      add_breadcrumb Referential.human_attribute_name("companies"), referential_companies_path(@referential)
    end
  end

  def new
    new! do
      add_breadcrumb Referential.human_attribute_name("companies"), referential_companies_path(@referential)
    end
  end
  
  def edit
    edit! do
      add_breadcrumb Referential.human_attribute_name("companies"), referential_companies_path(@referential)
      add_breadcrumb @company.name, referential_line_path(@referential, @company)
    end
  end

  protected
  def collection    
    @q = referential.companies.search(params[:q])
    @companies ||= @q.result(:distinct => true).order(:name).paginate(:page => params[:page])
  end


  def resource_url(company = nil)
    referential_company_path(referential, company || resource)
  end

  def collection_url
    referential_companies_path(referential)
  end

end
