require 'will_paginate/array'

class ValidationsController < ChouetteController
  defaults :resource_class => Validation
  
  respond_to :html, :only => [:show, :index, :new, :create, :delete]
  respond_to :js, :only => [:show, :index]
  belongs_to :referential

  # create => curl -F "file=@Citura.zip;filename=Citura.zip" -F "file=@parameters.json;filename=parameters.json" http://localhost:8080/chouette_iev/referentials/test/validator/neptune
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
        validation_service.delete(@validation.id)
        redirect_to referential_validations_path(@referential)      
      end
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  def export
    respond_to do |format|
      format.zip { send_file ValidationExport.new(resource, @referential.id, request).export, :type => :zip }
    end
  end
  
  protected

  alias_method :validation, :resource

  def validation_service
    ValidationService.new(@referential)
  end

  def build_resource(attributes = {})
    @validation ||= ValidationTask.new
  end
  
  def resource
    @validation ||= validation_service.find(params[:id] )
  end

  def collection
    @validations ||= validation_service.all.paginate(:page => params[:page])
  end
  
end
