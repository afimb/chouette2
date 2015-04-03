class ExportService
  
  attr_reader :referential
  
  def initialize(referential)
    @referential = referential
  end

  # Find an export whith his id
  def find(id)
    Export.new(IevApi.scheduled_job(referential.slug, id, { :action => "exporter" }))
  end

  # Find all exports
  def all
    [].tap do |jobs|
      Ievkit.jobs(referential.slug, { :action => "exporter" }).each do |job|
        jobs << Export.new( job )
      end
    end
  end

end
