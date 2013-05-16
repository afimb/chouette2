class Api::V1::AccessPointsController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::AccessPoint, :finder => :find_by_objectid!

protected

  def collection
    @access_points ||=  ( @referential ? @referential.access_points.search(params[:q]).result(:distinct => true) : [])

  end 

end

