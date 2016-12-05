class ComplianceChecksController < ChouetteController
  before_action :check_authorize, except: [:show, :index, :report, :download_validation, :rule_parameter_set, :export]

  helper IevkitViews::Engine.helpers
  defaults :resource_class => ComplianceCheck

  respond_to :html, :js
  respond_to :zip, :only => :export
  belongs_to :referential

  def index
    begin
      index! do
        build_breadcrumb :index
      end
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
      redirect_to referential_path(@referential)
    end
  end

  def show
    if resource.report?
      redirect_to report_referential_compliance_check_path(@referential.id, resource.id)
    else
      begin
        show! do |format|
          build_breadcrumb :show
        end
      rescue Ievkitdeprecated::Error, Faraday::Error => error
        logger.error("Iev failure : #{error.message}")
        flash[:error] = t(error.locale_for_error)
        redirect_to referential_path(@referential)
      end
    end
  end

  def progress
    @job = IevkitJob.new(@referential, resource)
    render json: @job.is_terminated? ? { redirect:  compliance_check_referential_import_path(@referential.id, resource.id) } : @job.progress_steps
  end

  def report
    @job = IevkitJob.new(@referential, resource)
    @job.search = params[:q][:search] if params[:q]
    @transport_datas_selected = params[:type_td]
    @default_view = params[:default_view] ? params[:default_view].to_sym : :tests
    @download_page = download_validation_referential_compliance_check_path(
      default_view: @default_view, referential_id: @referential.id, id: resource.id)
    @result, @datas, @sum_report, @errors = @job.send("#{@default_view}_views", (@transport_datas_selected != 'all' ? @transport_datas_selected : nil ))
    @elements_to_paginate = Kaminari.paginate_array(@datas)
                                    .page(params[:page])

    build_breadcrumb :report
  end

  def download_validation
    @job = IevkitJob.new(@referential, resource)
    datas, args = @job.download_validation_report(params[:default_view])
    send_data datas, args
  end

  def references
    @references = referential.send(params[:type]).where("name ilike ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json do
        render json: @references.collect { |child| { id: child.id, name: child.name } }
      end
    end
  end

  def rule_parameter_set
    begin
      @rule_parameter_set = resource.rule_parameter_set
      build_breadcrumb :rule_parameter_set
      render "rule_parameter_sets/show"
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
      redirect_to referential_path(@referential)
    end
  end

  def export
    respond_to do |format|
      format.zip { send_file ComplianceCheckExport.new(resource, @referential.id, request).export, :type => :zip }
    end
  end

  protected

  alias_method :compliance_check, :resource

  def compliance_check_service
    ComplianceCheckService.new(@referential)
  end

  def resource
    @compliance_check ||= compliance_check_service.find(params[:id])
    return @compliance_check unless @compliance_check.report
    @line_items = @compliance_check.report.line_items
    if @line_items.size > 500
      @line_items = Kaminari.paginate_array(@line_items).page(params[:page])
    end
    @compliance_check
  end

  def collection
    @compliance_checks ||= Kaminari.paginate_array(compliance_check_service.all.sort_by{ |compliance_check|
        compliance_check.created_at
      }.reverse).page(params[:page])
  end

end
