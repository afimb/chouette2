require 'will_paginate/array'

class ImportsController < ChouetteController
  respond_to :html, :xml, :json
  respond_to :js, :only => [:show, :index]
  belongs_to :referential

  # create => curl -F "file=@Citura_050115_220215_ref.zip;filename=Citura_050115_220215_ref.zip" -F "file=@parameters.json;filename=parameters.json" http://localhost:8080/mobi.chouette.api/referentials/test/importer/neptune
  # index curl http://localhost:8080/mobi.chouette.api/referentials/test/jobs
  # show curl http://localhost:8080/mobi.chouette.api/referentials/test/jobs

  def index
    index! do
      build_breadcrumb :index
    end
  end
  
  def show
    show! do
      build_breadcrumb :show
    end
  end
  
  protected

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
