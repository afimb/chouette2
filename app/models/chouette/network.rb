class Chouette::Network < Chouette::TridentActiveRecord
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  has_many :lines

  attr_accessor :source_type_name

  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}, :allow_nil => true, :allow_blank => true
  validates_presence_of :name

  def self.object_id_key
    "PTNetwork"
  end

  def self.nullable_attributes
    [:source_name, :source_type, :source_identifier, :comment]
  end

  def commercial_stop_areas
    Chouette::StopArea.joins(:children => [:stop_points => [:route => [:line => :network] ] ]).where(:networks => {:id => self.id}).uniq
  end

  def stop_areas
    Chouette::StopArea.joins(:stop_points => [:route => [:line => :network] ]).where(:networks => {:id => self.id})
  end

  def source_type_name
    # return nil if source_type is nil
    source_type && Chouette::SourceType.new( source_type.underscore)
  end

  def source_type_name=(source_type_name)
    self.source_type = (source_type_name ? source_type_name.camelcase : nil)
  end

  @@source_type_names = nil
  def self.source_type_names
    @@source_type_names ||= Chouette::SourceType.all.select do |source_type_name|
      source_type_name.to_i > 0
    end
  end


end

