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
    psteps = progress_steps
    psteps[:current_step] == psteps[:steps_count] &&
    psteps[:current_step_realized] == psteps[:current_step_total] &&
    psteps[:steps_percent] == psteps[:current_step_percent]
  end

  def result
    IevkitViews::ActionReport.new(referential, @all_links[:action_report], 'action_report').result
  end

  def progress_steps
    return {} if @all_links.blank?
    ievkit_views = IevkitViews::ActionReport.new(referential, @all_links[:action_report], 'action_report')
    ievkit_views.progression
    ievkit_views.datas
  end

  def extract_errors(report, validation = nil)
    errors = []
    begin
      errors = report.errors
    rescue => e
      Rails.logger.error "report errors could not be extracted, uses empty array"
      Rails.logger.error e.message
      unless validation.nil?
        Rails.logger.info ::Ievkit::Job.new(referential).get_job(validation[:validation_report])['validation_report']['errors']
      end
    end
    errors
  end

  def files_views(_type = nil)
    report = IevkitViews::ActionReport.new(@referential, @all_links[:action_report], 'action_report', @all_links[:validation_report], search)
    [
      report.result,
      report.search_for(report.files),
      report.sum_report(report.files),
      extract_errors(report)
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
      extract_errors(report)
    ]
  end

  def tests_views(_type = nil)
    report = IevkitViews::ValidationReport.new(referential, @all_links[:validation_report], 'validation_report', @all_links[:validation_report], search)
    [
      report.result,
      report.search_for(report.check_points),
      report.sum_report_for_tests(report.check_points),
      extract_errors(report, @all_links)
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
    _result, data, _sum_report, errors = send("#{default_view}_views")
    csv = @ievkit.download_validation_report(data, errors)
    [csv, filename: "#{@resource.name.parameterize}-#{Time.current.to_i}.csv"]
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
