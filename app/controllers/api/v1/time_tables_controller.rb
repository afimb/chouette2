class Api::V1::TimeTablesController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::TimeTable, :finder => :find_by_objectid!

protected

  def collection
    @time_tables ||= @referential.time_tables.search(params[:q]).result(:distinct => true)
  end 

end

