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
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  def show
    @import = resource if resource.kind_of?(Import)
    begin
      show! do |format|
        build_breadcrumb :show
        format.js { render 'show_for_import.js.coffee' if @import}
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
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
    @rule_parameter_set = resource.rule_parameter_set
    build_breadcrumb :edit
    render "rule_parameter_sets/show"
  end

  def create
    create!  do |success, failure|
      success.html { flash[:notice] = I18n.t('compliance_checks.new.flash'); redirect_to referential_compliance_checks_path(@referential) }
    end
  end
  
  def export
    respond_to do |format|
      format.zip { send_file ComplianceCheckExport.new(resource, @referential.id, request).export, :type => :zip }
    end
  end

  protected
  
  alias_method :compliance_check, :resource
  
  def  compliance_check_service
    ComplianceCheckService.new(@referential)
  end

  def  import_service
    ImportService.new(@referential)
  end
  
  def build_resource(attributes = {})
    @compliance_check ||= ComplianceCheck.new
  end
  
  def resource
    compliance_check ||= compliance_check_service.find(params[:id])
    if compliance_check.datas[:action] == "importer"
      @importer = import_service.find(params[:id])
    else
      @compliance_check = compliance_check
    end
  end
  
  def collection
    @compliance_checks ||= compliance_check_service.all.paginate(:page => params[:page])
  end
  
end
