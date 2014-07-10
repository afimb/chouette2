class Chouette::Hub::TimeTableExporter
  include ERB::Util
  attr_accessor :time_table, :directory, :template, :start_date, :end_date
  
  def initialize(time_table, directory)
    @time_table = time_table
    @directory = directory
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
    time_tables.each do |time_table|
      self.new(time_table, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|TIME_TABLE_COUNT", :arguments => {"0" => time_tables.size})
  end

  def save
    File.open(directory + hub_name , "a") do |f|
      f.write("PERIODE\n") if f.size == 0
      f.write(render)
    end if time_table.present?
  end
end

