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
  def delayed_import
    save_resources
    delay.import
  end

  @@root = "#{Rails.root}/tmp/imports"
  cattr_accessor :root

  def save_resources
    FileUtils.mkdir_p root
    FileUtils.cp resources.path, saved_resources 
  end

  after_destroy :destroy_resources
  def destroy_resources
    FileUtils.rm saved_resources if File.exists? saved_resources
  end

  def saved_resources
    "#{root}/#{id}.zip"
  end

  def import
    begin
      if resources
        with_original_filename do |file|
          # chouette-command checks the file extension (and requires .zip) :(
          loader.import file
        end
      else
        loader.import saved_resources
      end
      update_attribute :status, "completed"
    rescue => e
      Rails.logger.error "Import #{id} failed : #{e}, #{e.backtrace}"
      update_attribute :status, "failed"
    end
  end

end
