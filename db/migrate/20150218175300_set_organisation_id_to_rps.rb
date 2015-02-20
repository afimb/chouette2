class SetOrganisationIdToRps < ActiveRecord::Migration
  def up
    RuleParameterSet.all.each_with_index do |rps, index|
      rps.update_attributes :organisation_id => Referential.find( rps.referential_id).organisation_id,
                            :name => "#{rps.name} #{index}"
    end
  end

  def down
    RuleParameterSet.all.each_with_index do |rps, index|
      rps.update_attributes :organisation_id => nil
    end
  end
end
