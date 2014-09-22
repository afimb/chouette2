class BreadcrumbController < InheritedResources::Base

  include BreadcrumbHelper
  
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
