class ValidationService

  attr_reader :referential
  
  def initialize(referential)
    @referential = referential
  end

  # Find a validation whith this id
  def find(id)
    Validation.new(Ievkit.scheduled_job(referential.slug, id, { :action => "validator" }))
  end

  # Find all validations
  def all
    [].tap do |jobs|
      Ievkit.jobs(referential.slug, { :action => "validator" }).each do |job|
        jobs << Validation.new(job)
      end
    end
  end
  
end
