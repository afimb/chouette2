class ChouetteController < InheritedResources::Base

  include ApplicationHelper
  include BreadcrumbHelper
  
  before_filter :switch_referential

  layout "without_sidebar", :only => [:edit, :new, :update, :create]
  
  def switch_referential
    Apartment::Database.switch(referential.slug)
  end 

  def referential
    @referential ||= current_organisation.referentials.find params[:referential_id]  
  end 
  
  def show
    show! do 
      build_breadcrumb :show
    end
  end
  
  def index
    index! do 
      build_breadcrumb :index
    end
  end
    
  def edit
    edit! do
      build_breadcrumb :edit
    end
  end

  def update 
    update! do |success, failure|
      build_breadcrumb :edit
    end
  end

  def new
    new! do 
      build_breadcrumb :show
    end
  end
  
  def create
    create! do |success, failure|
      build_breadcrumb :show
    end
  end

end
