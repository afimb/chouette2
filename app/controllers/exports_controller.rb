require 'will_paginate/array'

class ExportsController < ChouetteController
  defaults :resource_class => Export
  
  respond_to :xml, :json
  respond_to :html, :only => [:show, :index, :new, :create, :delete]
  respond_to :js, :only => [:show, :index]
  belongs_to :referential

  #curl -F "file=@corolis.zip;filename=corolis_gtfs.zip" -F "file=@parameters.json;filename=parameters.json" http://localhost:8080/chouette_iev/referentials/corolis/exporter/gtfs
  
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
  
  def new
    begin
      new! do 
        puts "OK"
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end
  
  def create
    begin
      create! do 
        puts "OK"
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end
  
  def delete
    begin
      delete! do
        export_service.delete(@export.id)
        redirect_to referential_exports_path(@referential)      
      end
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

  def build_resource(attributes = {})
    @export ||= ExportTask.new
  end
  
  def resource
    @export ||= export_service.find( params[:id] )
  end

  def collection
    @exports ||= export_service.all.paginate(:page => params[:page])
  end
end
