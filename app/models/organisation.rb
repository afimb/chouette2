# -*- coding: utf-8 -*-
class Organisation < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  has_many :referentials, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
end
