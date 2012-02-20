class Referential < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :slug

  before_create :create_schema 
  before_destroy :destroy_schema

  def lines
    Chouette::Line.all
  end

  def networks
    Chouette::Network.all
  end

  def companies
    Chouette::Company.all
  end

  private 

  def create_schema
    Apartment::Database.create self.slug
  end

  def destroy_schema
    Apartment::Database.drop self.slug
  end
  
end
