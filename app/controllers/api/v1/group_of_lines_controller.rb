class Api::V1::GroupOfLinesController < Api::V1::ChouetteController

  defaults :resource_class => Chouette::GroupOfLine, :finder => :find_by_objectid!

protected

  def collection
    @group_of_lines ||=  ( @referential ? @referential.group_of_lines.search(params[:q]).result(:distinct => true) : [])

  end 

end