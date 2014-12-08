class Chouette::Hub::TimeTableExporter
  include ERB::Util
  attr_accessor :time_table, :directory, :template, :start_date, :end_date, :identifier
  
  def initialize(time_table, directory, identifier)
    @time_table = time_table
    @directory = directory
    @identifier = identifier
    @template = File.open('app/views/api/hub/periodes.hub.erb' ){ |f| f.read }
    @calendar = ""
    s_date = @time_table.start_date
    e_date = @time_table.end_date
    while s_date <= e_date
      if time_table.include_day?(s_date)
        @calendar += "1"
      else
        @calendar += "0"
      end
      s_date = s_date.next_day
    end
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/PERIODE.TXT"
  end
  
  def self.save(time_tables, directory, hub_export)
    identifier = 1
    time_tables.each do |time_table|
      self.new(time_table, directory, identifier).tap do |specific_exporter|
        specific_exporter.save
        identifier += 1
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|TIME_TABLE_COUNT", :arguments => {"0" => time_tables.size})
  end

  def save
    File.open(directory + hub_name , "a:Windows_1252") do |f|
      f.write("PERIODE\u000D\u000A") if f.size == 0
      f.write(render)
    end if time_table.present?
  end
end

