require 'will_paginate/array'

class ImportsController < ChouetteController
  defaults :resource_class => Import
  
  respond_to :html, :only => [:show, :index, :new, :create, :delete]
  respond_to :js, :only => [:show, :index]
  belongs_to :referential

  # create => curl -F "file=@Citura.zip;filename=Citura.zip" -F "file=@parameters.json;filename=parameters.json" http://localhost:8080/chouette_iev/referentials/test/importer/neptune
  # index curl http://localhost:8080/mobi.chouette.api/referentials/test/jobs
  # show curl http://localhost:8080/mobi.chouette.api/referentials/test/jobs

  
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
        import_service.delete(@import.id)
        redirect_to referential_imports_path(@referential)      
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end
  
  protected

  def import_service
    ImportService.new(@referential)
  end

  def build_resource(attributes = {})
    @import ||= ImportTask.new
  end
  
  def resource
    @import ||= import_service.find( params[:id] )
  end

  def collection
    @imports ||= import_service.all.paginate(:page => params[:page])
  end
  
end
