module JobStatusIconHelper

  def job_status_title(object)
    status = object.status
    name = object.name
    
    title = ""
    if %w{ aborted canceled }.include?(status)
      title += "<span class='name aborted'><i class='fa fa-times'></i>"
    elsif %w{ created scheduled }.include?(status)
      title += "<span class='name processed'><i class='fa fa-spinner fa-spin'></i>"
    elsif %w{ terminated}.include?(status)
      title += "<span class='name terminated'><i class='fa fa-check'></i>"
    end

    title += "#{truncate(name, :length => 20)}</span>"
    title.html_safe
  end
  
end
