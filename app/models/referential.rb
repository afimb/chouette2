class Referential < ActiveRecord::Base
  validates_presence_of :name 
  validates_presence_of :slug

  
end
