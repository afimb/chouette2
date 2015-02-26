require 'will_paginate/array'

class ExportsController < ChouetteController
  respond_to :html, :xml, :json
  respond_to :js, :only => [:show, :index]
  belongs_to :referential

  protected

  def test
    test = IevApi.jobs(@referential.slug, { :action => "exporter" }).map do |export_hash|
      export = Export.new(export_hash)
    end
  end
  
  def collection
    @exports ||= test.paginate(:page => params[:page])    
  end
  
end
