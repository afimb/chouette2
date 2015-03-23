class ImportService

  attr_reader :referential
  
  def initialize( referential )
    @referential = referential
  end

  # Find an import whith his id
  def find(id)
    Import.new( Ievkit.scheduled_job(referential.slug, id, { :action => "importer" }) )
  end

  # Find all imports
  def all
    [].tap do |jobs|
      Ievkit.jobs(referential.slug, { :action => "importer" }).each do |job|
        jobs << Import.new( job )
      end
    end
  end
  
end
