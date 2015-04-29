# coding: utf-8
require 'will_paginate/array'
require 'open-uri'

class ImportsController < ChouetteController
  defaults :resource_class => Import
  
  respond_to :html, :only => [:show, :index, :destroy, :imported_file, :rule_parameter_set]
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

  def imported_file
    begin
      send_file open(resource.file_path), { :type => "application/#{resource.filename_extension}", :disposition => "attachment", :filename => resource.filename }
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end

  def rule_parameter_set
    begin
      build_breadcrumb :show
      @rule_parameter_set = RuleParameterSet.new(:name => "").tap{ |rps| rps.parameters = resource.rule_parameter_set["validation"] }
      render "rule_parameter_set"
    rescue Ievkit::Error => error
      logger.error("Iev failure : #{error.message}")
      flash[:error] = t('iev.failure')
      redirect_to referential_path(@referential)
    end
  end
  
  protected
  alias_method :import, :resource

  def import_service
    ImportService.new(@referential)
  end
  
  def resource
    @import ||= import_service.find( params[:id] )
  end

  def collection
    @imports ||= import_service.all.paginate(:page => params[:page])
  end
  
end
