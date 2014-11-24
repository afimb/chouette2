class ExportsController < ChouetteController
  defaults :resource_class => Export
  
  respond_to :html, :xml, :json, :js
  respond_to :zip, :only => :show

  belongs_to :referential

  def new
    new! do
      build_breadcrumb :new
      available_exports
    end
  end

  def create
    if (params[:export][:type] == "HubExport") && Chouette::VehicleJourneyAtStop.all.count > 50000
      flash[:notice] = I18n.t("formtastic.titles.export.vjas.size", size: Chouette::VehicleJourneyAtStop.all.count)
      redirect_to new_referential_export_path(@referential)
    elsif (params[:export][:type] == "HubExport") && (params[:export][:start_date].empty? || params[:export][:end_date].empty?)
      flash[:notice] = I18n.t("formtastic.titles.export.dates.not_nul")
      redirect_to new_referential_export_path(@referential)
    else
      create! do |success, failure|
        success.html { flash[:notice] = I18n.t('exports.new.flash')+"<br/>"+I18n.t('exports.new.flash2'); redirect_to referential_exports_path(@referential) }
      end
    end
  end

  def show
    show! do |format|
      format.zip { send_file @export.file, :type => :zip }
      build_breadcrumb :show
    end
  end

  def references
    @references = referential.send(params[:type]).where("name ilike ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json do
        render :json => @references.collect { |child| { :id => child.id, :name => child.name } }
      end
    end
  end

  protected

  def available_exports
    @available_exports ||= Export.types.collect do |type|
      unless @export.type == type
        @referential.exports.build :type => type
      else
        @export
      end
    end
  end

  # FIXME why #resource_id is nil ??
  def build_resource
    super.tap do |export|
      export.referential_id = @referential.id
    end
  end

  def collection
    @exports ||= end_of_association_chain.order('created_at DESC').paginate(:page => params[:page])
  end

end
