class Chouette::Hub::GroupOfLinesExporter
  include ERB::Util
  attr_accessor :group_of_lines, :directory, :template
  
  def initialize(group_of_lines, directory)
    @group_of_lines = group_of_lines
    @directory = directory
    @template = File.open('app/views/api/hub/groupe_de_lignes.hub.erb' ){ |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/GROUPELIGNE.TXT"
  end
  
  def self.save( groups_of_lines, directory, hub_export)
    groups_of_lines.each do |group_of_lines|
      self.new( group_of_lines, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|GROUP_OF_LINES_COUNT", :arguments => {"0" => groups_of_lines.size})
  end
  
  def save
    File.open(directory + hub_name , "a:ISO_8859_1") do |f|
      f.write("GROUPELIGNE\u000D\u000A") if f.size == 0
      f.write(render)
    end if group_of_lines.present?
  end
end

