class SetDefaultValueForDataFormatInOrganisation < ActiveRecord::Migration[4.2]
  def change
    Organisation.all.each do |organisation|
      if organisation.data_format.neptune?
        organisation.update :data_format => "neptune"
      end
    end
    Referential.all.each do |referential|
      if referential.data_format.neptune?
        referential.update :data_format => "neptune"
      elsif referential.data_format.netex?
        referential.update :data_format => "netex"
      elsif referential.data_format.gtfs?
        referential.update :data_format => "gtfs"
      elsif referential.data_format.hub?
        referential.update :data_format => "hub"
      end
    end
    
    change_column :organisations, :data_format, :string, :default => "neptune"
  end
end
