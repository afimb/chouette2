require 'will_paginate/array'
require 'open-uri'

class ExportsController < ChouetteController
  defaults :resource_class => Export
  
  respond_to :html, :only => [:show, :index, :destroy, :exported_file]
  respond_to :js, :only => [:index]
  belongs_to :referential

  def index
    begin
      index! do 
        build_breadcrumb :index
      end
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
      redirect_to referential_path(@referential)
    end
  end

  def show
    begin
      show! do 
        build_breadcrumb :show
      end
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
      redirect_to referential_path(@referential)
    end
  end

  def destroy    
    begin
      destroy!
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
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
    rescue Ievkit::Error, Faraday::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t(error.locale_for_error)
      redirect_to referential_path(@referential)
    end
  end

  protected
  
  def export_service
    ExportService.new(@referential)
  end
  
  def resource
    @export ||= export_service.find( params[:id] )
    @line_items = @export.report.line_items
    if @line_items.size > 500
      @line_items = @line_items.paginate(page: params[:page], per_page: 20)
    end
    @export
  end

  def collection
    @exports ||= export_service.all.sort_by{ |export| export.created_at }.reverse.paginate(:page => params[:page])
  end
end
