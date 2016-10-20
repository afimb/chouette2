class IevkitJob
  attr_reader :all_links, :result, :referential, :resource
  attr_accessor :search

  def initialize(referential, resource)
    @referential = referential
    @resource = resource
    load_ievkit
  end

  def list_links
    @all_links = {}.tap { |hash| @resource.datas[:links].map { |link| hash[link['rel'].to_sym] = link['href'] } }
  end

  def ievkit_cancel_or_delete(action)
    return if @all_links.blank?
    @ievkit.delete_job(@all_links[action.to_sym])
  end

  def is_terminated?
    return false if @all_links.blank?
    return true if terminated?
    if @ievkit.terminated_job?(@all_links[:forwarding_url])
      update_links
      terminated!
    else
      false
    end
  end

  def result
    IevkitViews::ActionReport.new(referential, @all_links[:action_report], 'action_report').result
  end

  def progress_steps
    datas = {}
    return { error_code: I18n.t("iev.errors.#{error_code.downcase}", default: error_code.downcase.humanize) } if error_code.present?
    return datas if @all_links.blank?
    if @all_links[:action_report].blank?
      update_links
    else
      ievkit_views = IevkitViews::ActionReport.new(referential, @all_links[:action_report], 'action_report')
      ievkit_views.progression
      datas = ievkit_views.datas
    end
    datas
  end

  def files_views(_type = nil)
    report = IevkitViews::ActionReport.new(@referential, @all_links[:action_report], 'action_report', @all_links[:validation_report], search)
    [
      report.result,
      report.search_for(report.files),
      report.sum_report(report.files),
      report.errors
    ]
  end

  def transport_datas_views(type = nil)
    report = IevkitViews::ActionReport.new(referential, @all_links[:action_report], 'action_report', @all_links[:validation_report], search)
    if type
      datas = []
      datas << report.collections('line') if type == 'line'
      datas << report.objects(type) if type != 'line'
    else
      datas = [
        report.collections('line'),
        report.objects
      ]
    end
    files = report.sort_datas(datas)
    [
      report.result,
      report.search_for(files),
      report.sum_report(files),
      report.errors
    ]
  end

  def tests_views(_type = nil)
    report = IevkitViews::ValidationReport.new(referential, @all_links[:validation_report], 'validation_report', @all_links[:validation_report], search)
    [
      report.result,
      report.search_for(report.check_points),
      report.sum_report_for_tests(report.check_points),
      report.errors
    ]
  end

  def result_action_report
    report = @ievkit.get_job(@all_links[:action_report])
    return 'error' unless report
    report['action_report']['result'].downcase
  end

  def validation_report
    @ievkit.get_job(@all_links[:validation_report])
  end

  def download_result(default_view)
    default_view = default_view.present? ? default_view : 'files'
    self.convert_job? ? download_conversion : download_validation_report(default_view)
  end

  def download_validation_report(default_view)
    result, datas, errors = send("#{default_view}_views")
    csv = []
    datas.each do |el|
      t = [el[:name], I18n.t("compliance_check_results.severities.#{el[:status]}"), el[:count_error], el[:count_warning]]
      csv << t.join(';')
      next unless el[:check_point_errors]
      el[:check_point_errors].each do |index|
        error = errors[index]
        next unless error
        t = ['']
        if error[:source][:file] && error[:source][:file][:filename]
          filename = [error[:source][:file][:filename]]
          if error[:source][:file][:line_number].to_i > 0
            filename << "#{I18n.t('report.file.line')} #{error[:source][:file][:line_number]}"
          end
          if error[:source][:file][:column_number].to_i > 0
            filename << "#{I18n.t('report.file.column')} #{error[:source][:file][:column_number]}"
          end
          t << filename.join(' ')
        end
        t << error[:error_name]
        csv << t.join(';')
      end
    end
    [csv.join("\n"), filename: "#{@resource.name.parameterize}-#{Time.current.to_i}.csv"]
  end

  def parameters
    self[:parameters].is_a?(Hash) ? self[:parameters].symbolize_keys! : {}
  end

  protected

  def load_ievkit
    @ievkit = Ievkit::Job.new(referential)
    list_links
  end
end
