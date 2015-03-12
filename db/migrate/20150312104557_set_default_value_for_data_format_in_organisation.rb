class SetDefaultValueForDataFormatInOrganisation < ActiveRecord::Migration
  def change
    Organisation.all.each do |organisation|
      if organisation.data_format.neptune?
        organisation.update_attributes :data_format => "neptune"
      end
    end
    Referential.all.each do |referential|
      if referential.data_format.neptune?
        referential.update_attributes :data_format => "neptune"
      elsif referential.data_format.netex?
        referential.update_attributes :data_format => "netex"
      elsif referential.data_format.gtfs?
        referential.update_attributes :data_format => "gtfs"
      elsif referential.data_format.hub?
        referential.update_attributes :data_format => "hub"
      end
    end
    
    change_column :organisations, :data_format, :string, :default => "neptune"
  end
end
