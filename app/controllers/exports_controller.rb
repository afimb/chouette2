require 'open-uri'

class ExportsController < ChouetteController
  helper IevkitViews::Engine.helpers
  defaults :resource_class => Export

  respond_to :html, :only => [:show, :index, :destroy, :exported_file]
  respond_to :js, :only => [:index]
  belongs_to :referential

  def index
    begin
      index! do
        build_breadcrumb :index
      end
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def show
    begin
      show! do
        build_breadcrumb :show
      end
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def destroy
    begin
      destroy!
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def exported_file
    # WARNING : files under 10kb in size get treated as StringIO by OpenUri
    # http://stackoverflow.com/questions/10496874/why-does-openuri-treat-files-under-10kb-in-size-as-stringio
    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0
    begin
      send_file open(resource.file_path), { :type => "application/#{resource.filename_extension}", :disposition => "attachment", :filename => resource.filename }
    rescue Ievkitdeprecated::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error) if error.methods.include? :locale_for_error
      redirect_to referential_path(@referential)
    end
  end

  def export
    respond_to do |format|
      format.zip { send_file ComplianceCheckExport.new(resource, @referential.id, request).export, type: :zip }
    end
  end

  def compliance_check
    @job = IevkitJob.new(@referential, resource)
    @job.search = params[:q][:search] if params[:q]
    @transport_datas_selected = params[:type_td]
    @default_view = params[:default_view] ? params[:default_view].to_sym : :tests
    @download_page = download_validation_referential_compliance_check_path(
      default_view: @default_view, referential_id: @referential.id, id: resource.id)
    @result, @datas, @sum_report, @errors = @job.send("#{@default_view}_views", (@transport_datas_selected != 'all' ? @transport_datas_selected : nil ))
    @elements_to_paginate = Kaminari.paginate_array(@datas)
                                    .page(params[:page])
    build_breadcrumb :compliance_check
    render "compliance_checks/report"
  end

  protected

  def export_service
    ExportService.new(@referential)
  end

  def resource
    @export ||= export_service.find( params[:id] )
    return @export unless @export.report
    @line_items = @export.report.line_items
    if @line_items.size > 500
      @line_items = Kaminari.paginate_array(@line_items).page(params[:page])
    end
    @export
  end

  def collection
    @exports ||= Kaminari.paginate_array(export_service.all.sort_by{ |export|
        export.created_at
      }.reverse).page(params[:page])
  end
end
