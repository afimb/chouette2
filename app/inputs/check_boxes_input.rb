class CheckBoxesInput < Formtastic::Inputs::CheckBoxesInput
  
  def selected_values
    if object.respond_to?(method)
      selected_items = [object.send(method)].compact.flatten
      
      # FIX for ids only
      return selected_items.map(&:to_s).compact if selected_items.all?{ |i| i.is_a? Integer} 
      
      [*selected_items.map { |o| send_or_call_or_object(value_method, o) }].compact
    else
      []
    end
  end
  
end

