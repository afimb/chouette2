class ImportService

  attr_reader :referential
  
  def initialize( referential )
    @referential = referential
  end

  # Merge report import and datas from import
  def find(id)
    all.find {|v| "#{v.id}" == id }
  end

  # Find all imports
  def all
    IevApi.jobs(referential.slug, { :action => "importer" }).map do |import_hash|
      Import.new( import_hash )
    end
  end

end
