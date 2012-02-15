class Referential < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :slug

  def lines
    Chouette::Line.all
  end 

  
end
