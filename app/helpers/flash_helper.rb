module FlashHelper

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def flash_message_for(flash_type, message)
    case flash_type
      when :success
        "<i class='fa fa-check-circle'></i>  #{message}".html_safe
      when :error
        "<i class='fa fa-minus-circle'></i> #{message}".html_safe
      when :alert
        "<i class='fa fa-exclamation-circle'></i> #{message}".html_safe 
      when :notice
        "<i class='fa fa-info-circle'></i> #{message}".html_safe
      else
        message
    end
  end
  
end
