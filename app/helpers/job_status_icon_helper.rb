module JobStatusIconHelper

  def has_errors(object)
    begin
      return object.report && object.report.errors.count > 0
    rescue => e # ignored
    end
  end

  def has_failure(object)
    begin
      return object.report && object.report.failure_code?
    rescue => e # ignored
    end
  end

  def job_status_title(object)
    status = object.status
    name = object.name
    object_name = object.class.model_name.human.capitalize
    not_ok = has_failure(object)
    errors = has_errors(object)

    title = ''
    if %w{ aborted canceled }.include?(status) || not_ok
      title += '<span class="name aborted"><i class="fa fa-times"></i>'
    elsif %w{ started scheduled }.include?(status)
      title += "<span class=\"name processed progress\" title=\"#{I18n.t('job_status.title.processed')}\"><i class=\"fa fa-clock-o\"></i>"
    elsif errors
      title += '<span class="name terminated errors"><i class="fa fa-times aborted"></i>'
    elsif %w{ terminated }.include?(status)
      title += '<span class="name terminated"><i class="fa fa-check"></i>'
    end

    title += "#{object_name} #{name}</span>"

    title.html_safe
  end

  def job_status_short_title(object)
    name = object.name
    object_name = object.class.model_name.human.capitalize

    "#{object_name} #{name}".html_safe
  end

end
