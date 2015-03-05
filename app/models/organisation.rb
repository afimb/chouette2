# -*- coding: utf-8 -*-
class Organisation < ActiveRecord::Base
  include DataFormatEnumerations
  
  has_many :users, :dependent => :destroy
  has_many :referentials, :dependent => :destroy
  has_many :rule_parameter_sets, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  after_create :add_rule_parameter_set

  attr_accessible :data_format, :name
  
  def add_rule_parameter_set
    RuleParameterSet.default_for_all_modes( self).save
  end
end
