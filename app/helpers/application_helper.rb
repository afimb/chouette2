module ApplicationHelper

  def selected_referential?
    @referential.present? and not @referential.new_record?
  end

  
end
