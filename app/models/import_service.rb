class ImportService

  attr_reader :referential
  
  def initialize( referential )
    @referential = referential
  end

  # Find an import whith his id
  def find(id)
    Import.new( IevApi.scheduled_job(referential.slug, id, { :action => "importer" }) )
  end

  # Find all imports
  def all
    IevApi.jobs(referential.slug, { :action => "importer" }).map do |import_hash|
      Import.new( import_hash  )
    end
  end

end
