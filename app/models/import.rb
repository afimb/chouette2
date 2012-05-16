class Import < ActiveRecord::Base
  belongs_to :referential

  validates_presence_of :referential_id
  validates_presence_of :resources

  validates_inclusion_of :status, :in => %w{ pending completed failed }

  attr_accessor :resources
  attr_accessor :loader

  def loader
    @loader ||= ::Chouette::Loader.new(referential.slug)
  end

  def with_original_filename
    Dir.mktmpdir do |tmp_dir|
      tmp_link = File.join(tmp_dir, resources.original_filename)
      FileUtils.ln_s resources.path, tmp_link
      yield tmp_link
    end
  end

  before_validation :define_default_attributes, :on => :create
  def define_default_attributes
    self.status ||= "pending"
  end

  after_create :import
  def import
    begin
      with_original_filename do |file|
        # chouette-command checks the file extension (and requires .zip) :(
        loader.import file
      end
      update_attribute :status, "completed"
    rescue
      update_attribute :status, "failed"
    end
  end

  

end
