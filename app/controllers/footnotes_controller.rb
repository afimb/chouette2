class FootnotesController < ChouetteController
  before_action :check_authorize, except: [:show, :index]

  defaults :resource_class => Chouette::Footnote
  respond_to :html

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
    @q = referential.footnotes.search(params[:q])
    @footnotes ||= @q.result(:distinct => true).order(:label).page(params[:page])
  end

  def resource_url(footnote = nil)
    referential_footnote_path(referential, footnote || resource)
  end

  def collection_url
    referential_footnotes_path(referential)
  end

  def footnote_params
    params.require(:footnote).permit(:objectid, :object_version, :creation_time, :creator_id, :version_date, :label, :code  )
  end

end
