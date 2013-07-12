# This migration comes from ninoxe_engine (originally 20130710122648)
class SetAccessibiliityToExistingStopArea < ActiveRecord::Migration
  def up
    Chouette::StopArea.all.each do |s|
      if s.mobility_restricted_suitability.nil?
        s.mobility_restricted_suitability = false
        s.stairs_availability = false
        s.lift_availability = false
        s.int_user_needs = 0
        s.save
      end
    end
  end

  def down
  end
end
