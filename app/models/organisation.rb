# -*- coding: utf-8 -*-
class Organisation < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :referentials, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true
end
