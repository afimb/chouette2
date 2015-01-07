class ExtendedTimePickerInput < Formtastic::Inputs::TimePickerInput
  
  def value
    return options[:input_html][:value] if options[:input_html] && options[:input_html].key?(:value)
    val = object.send(method)
    return "00:00:00" if val.is_a?(Date)
    return val.strftime("%H:%M:%S") if val.is_a?(Time)
    return "00:00:00" if val.nil?
    val.to_s
  end     
  
end
