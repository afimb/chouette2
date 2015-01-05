class AutocompleteStopAreasController < InheritedResources::Base
  respond_to :json, :only => [:index, :children, :parent, :physicals]
  
  before_filter :switch_referential
  
  def switch_referential
    Apartment::Tenant.switch(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]  
  end 

  protected

  def collection
    result = []
    if physical_filter?
     result = referential.stop_areas.physical
    elsif itl_exclude_filter?
      result = Chouette::StopArea.where("area_type != 'ITL'")
    elsif target_type? && relation_parent?
     result = Chouette::StopArea.new( :area_type => params[ :target_type ] ).possible_parents
    elsif target_type? && relation_children?
     result = Chouette::StopArea.new( :area_type => params[ :target_type ] ).possible_children
    else
      result = referential.stop_areas
    end
    @stop_areas = result.select{ |p| p.name =~ /#{params[:q]}/i  }
    @stop_areas
  end

  def target_type?
    params.has_key?( :target_type) && params.has_key?( :relation )
  end

  def relation_parent?
    params[ :relation ] == "parent"
  end

  def relation_children?
    params[ :relation ] == "children"
  end

  def itl_exclude_filter?
    params[:filter] == "itl_excluded"
  end

  def physical_filter?
    params[:filter] == "physical"
  end

end

