class InsertDefaultOrganisation < ActiveRecord::Migration
  def up
    organisation = Organisation.find_or_create_by!(:name => "Chouette")
    Referential.where(  :organisation_id => nil).each do |r|
      r.update_attributes :organisation_id => organisation.id
    end
    User.where(  :organisation_id => nil).each do |r|
      r.update_attributes :organisation_id => organisation.id
    end
    Organisation.all.each do |organisation|
      RuleParameterSet.default_for_all_modes( organisation).save if organisation.rule_parameter_sets.empty?
    end

  end

  def down
    organisations = Organisation.where( :name => "Chouette")
    organisations.first.destroy unless organisations.empty?
  end
end

