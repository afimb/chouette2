require 'will_paginate/array'

class ComplianceChecksController < ChouetteController
  defaults :resource_class => ComplianceCheck

  respond_to :html, :js
  respond_to :zip, :only => :export
  belongs_to :referential

  def index
    begin
      index! do
        build_breadcrumb :index
      end
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.exception.default')
      redirect_to referential_path(@referential)
    end
  end

  def show
    begin
      show! do |format|
        build_breadcrumb :show
      end
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.exception.default')
      redirect_to referential_path(@referential)
    end
  end

  def report
    resource
    build_breadcrumb :report
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
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.exception.default')
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
  end

  def collection
    @compliance_checks ||= compliance_check_service.all.paginate(:page => params[:page])
  end

end
