class CodespacesController < ChouetteController
  before_action :check_authorize, except: [:show, :index]
  before_action :check_admin, :only => [:new, :edit]

  defaults :resource_class => Chouette::Codespace
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
    @q = referential.codespaces.search(params[:q])
    @codespaces ||= @q.result(:distinct => true).order(:xmlns).page(params[:page])
  end


  def resource_url(codespace = nil)
    referential_codespace_path(referential, codespace || resource)
  end

  def collection_url
    referential_codespace_path(referential)
  end

  def codespace_params
    params.require(:codespace).permit( :objectid, :object_version, :creation_time, :creator_id, :xmlns, :xmlns_url )
  end

  protected
  def check_admin
    redirect_to referential_codespaces_path(@referential, @codespaces) unless current_user.admin?
  end
end
