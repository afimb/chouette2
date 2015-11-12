module JobStatusIconHelper

  def job_status_title(object)
    status = object.status
    name = object.name
    object_name = object.class.model_name.human.capitalize

    title = ''
    if %w{ aborted canceled }.include?(status)
      title += '<span class="name aborted"><i class="fa fa-times"></i>'
    elsif %w{ started scheduled }.include?(status)
      title += "<span class=\"name processed progress\" title=\"#{I18n.t('job_status.title.processed')}\"><i class=\"fa fa-clock-o\"></i>"
    elsif %w{ terminated }.include?(status)
      title += '<span class="name terminated"><i class="fa fa-check"></i>'
    end

    title += "#{object_name} #{truncate(name, length: 20)}</span>"

    title.html_safe
  end

  def job_status_short_title(object)
    name = object.name
    object_name = object.class.model_name.human.capitalize

    "#{object_name} #{truncate(name, length: 20)}".html_safe
  end

end
