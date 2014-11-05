class Chouette::Hub::CompanyExporter
  include ERB::Util
  attr_accessor :company, :directory, :template
  
  def initialize(company, directory)
    @company = company
    @directory = directory
    @template = File.open('app/views/api/hub/transporteurs.hub.erb' ){ |f| f.read }
  end
  
  def render()
    ERB.new(@template).result(binding)
  end
  
  def hub_name
    "/TRANSPORTEUR.TXT"
  end
  
  def self.save( companies, directory, hub_export)
    companies.each do |company|
      self.new( company, directory).tap do |specific_exporter|
        specific_exporter.save
      end
    end
    hub_export.log_messages.create( :severity => "ok", :key => "EXPORT|COMPANY_COUNT", :arguments => {"0" => companies.size})
  end
  
  def save
    File.open(directory + hub_name , "a:ISO_8859_1") do |f|
      f.write("TRANSPORTEUR\u000D\u000A") if f.size == 0
      f.write(render)
    end if company.present?
  end
end

