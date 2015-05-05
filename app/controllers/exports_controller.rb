require 'will_paginate/array'
require 'open-uri'

class ExportsController < ChouetteController
  defaults :resource_class => Export
  
  respond_to :html, :only => [:show, :index, :destroy, :exported_file]
  respond_to :js, :only => [:show, :index]
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
    begin
      show! do 
        build_breadcrumb :show
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  def destroy    
    begin
      destroy!
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  def exported_file
    begin
      send_file open(resource.file_path), { :type => "application/#{resource.filename_extension}", :disposition => "attachment", :filename => resource.filename }
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  protected
  
  def export_service
    ExportService.new(@referential)
  end
  
  def resource
    @export ||= export_service.find( params[:id] )
  end

  def collection
    @exports ||= export_service.all.paginate(:page => params[:page])
  end
end
