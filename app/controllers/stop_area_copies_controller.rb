class StopAreaCopiesController < ChouetteController
  belongs_to :referential do
    belongs_to :stop_area, :parent_class => Chouette::StopArea 
  end
  
  actions :new, :create
  respond_to :html, :only => :new
  
  def new    
    @stop_area_copy = StopAreaCopy.new(:source_id => parent.id, :hierarchy => params[:hierarchy])
    if @stop_area_copy.hierarchy == "child"
      if parent.area_type.underscore == "stop_place"
        @stop_area_copy.area_type="commercial_stop_point"
      else
        @stop_area_copy.area_type="boarding_position"
      end
    else
      if parent.area_type.underscore == "stop_place" || parent.area_type.underscore == "commercial_stop_point"
        @stop_area_copy.area_type="stop_place"
      else
        @stop_area_copy.area_type="commercial_stop_point"
      end
    end
    new!
  end
# TODO
  def create
    @stop_area_copy = StopAreaCopy.new(params[:stop_area_copy])
    if @stop_area_copy.save
      redirect_to referential_stop_area_path( @referential,parent ), notice: I18n.t("stop_area_copies.new.success")
    else
      flash[:error] = I18n.t("stop_area_copies.errors.copy_aborted") + "<br>" + @stop_area_copy.errors.full_messages.join("<br>")
      render :action => :new
    end
  end

  protected 

end
