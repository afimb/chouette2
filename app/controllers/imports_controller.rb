require 'will_paginate/array'

class ImportsController < ChouetteController
  respond_to :html, :xml, :json
  respond_to :js, :only => [:show, :index]
  belongs_to :referential

  protected

  def test
    test = IevApi.jobs(@referential.slug, { :action => "importer" }).map do |import_hash|
      Import.new(import_hash)
    end
  end
  
  def collection
    @imports ||= test.paginate(:page => params[:page])    
  end
  
end
