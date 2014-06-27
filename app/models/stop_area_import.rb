# -*- coding: utf-8 -*-

class StopAreaImport   
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :file
  
  validates_presence_of :file

  def initialize(attributes = {})    
    attributes.each { |name, value| send("#{name}=", value) }
  end
  
  def persisted?
    false
  end
  
  def save
    begin
      Chouette::StopArea.transaction do
        if imported_stop_areas.map(&:valid?).all? 
          imported_stop_areas.each(&:save!)
          true
        else
          imported_stop_areas.each_with_index do |imported_stop_area, index|
            imported_stop_area.errors.full_messages.each do |message|
              errors.add :base, I18n.t("stop_area_import.errors.invalid_stop_area", :column => index+2, :message => message)
            end
          end
          false
        end
      end
    rescue Exception => exception
      errors.add :base, I18n.t("stop_area_import.errors.exception", :message => exception.message)
      false
    end
  end   
  
  def imported_stop_areas
    @imported_stop_areas ||= load_imported_stop_areas
  end  

  def load_imported_stop_areas
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      stop_area = Chouette::StopArea.find_by_id(row["id"]) || Chouette::StopArea.new
       stop_area.attributes = row.to_hash.slice(*Chouette::StopArea.accessible_attributes)
      stop_area
    end
  end
  
  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xls' then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end
  
end
