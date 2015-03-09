class SetOrganisationIdToRps < ActiveRecord::Migration
  # class RuleParameterSet  < ActiveRecord::Base
  #   attr_accessor :referential_id
  #   attr_accessor :organisation_id
  #   attr_accessor :name
  # end
  # def up
  #   RuleParameterSet.all.each_with_index do |rps, index|
  #     rps.update_attributes :organisation_id => Referential.find( rps.referential_id).organisation_id,
  #                           :name => "{rps.name} {index}"
  #   end
  # end

  # def down
  #   RuleParameterSet.all.each_with_index do |rps, index|
  #     rps.update_attributes :organisation_id => nil
  #   end
  # end
end
