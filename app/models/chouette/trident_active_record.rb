class Chouette::TridentActiveRecord < Chouette::ActiveRecord
    before_validation :prepare_auto_columns
    after_validation :reset_auto_columns
    
    after_save :build_objectid

    self.abstract_class = true
    #
    # triggers to generate objectId and objectVersion 
    # TODO setting prefix in referential object
    
    def self.object_id_key
      model_name
    end

    def referential
      @referential ||= Referential.where(:slug => Apartment::Tenant.current).first!
    end

    def format_restricted?(format)
      referential.data_format == nil || referential.data_format.to_sym == format.to_sym
    end
    
    def prefix
      self.referential.prefix
    end

    def prepare_auto_columns
      # logger.info 'calling before_validation'
      # logger.info 'start before_validation : '+self.objectid.to_s
      if self.objectid.nil? || self.objectid.blank?
        # if empty, generate a pending objectid which will be completed after creation
        if self.id.nil?
           self.objectid = "#{prefix}:#{self.class.object_id_key}:__pending_id__#{rand(1000)}"
        else
           self.objectid = "#{prefix}:#{self.class.object_id_key}:#{self.id}"
           fix_uniq_objectid
        end
      elsif not self.objectid.include? ':'
        # if one token : technical token : completed by prefix and key
        self.objectid = "#{prefix}:#{self.class.object_id_key}:#{self.objectid}"
      end
      # logger.info 'end before_validation : '+self.objectid
      # initialize or update version
      if self.object_version.nil?
        self.object_version = 1
      else
        self.object_version += 1
      end
      self.creation_time = Time.now
      self.creator_id = 'chouette'
    end
    
    def reset_auto_columns
      clean_object_id unless self.errors.nil? || self.errors.empty?
    end
    
    def clean_object_id
      if self.objectid.include?("__pending_id__")
        self.objectid=nil
      end
    end  
    
    def fix_uniq_objectid
        base_objectid = self.objectid.rpartition(":").first
        self.objectid = "#{base_objectid}:#{self.id}"
        if !self.valid?
          base_objectid="#{self.objectid}_"
          cnt=1
          while !self.valid? 
            self.objectid = "#{base_objectid}#{cnt}"
            cnt += 1
          end
        end
      
    end
    
    def build_objectid
      #logger.info 'start after_create : '+self.objectid
      if self.objectid.include? ':__pending_id__'
        fix_uniq_objectid
        self.update_attributes( :objectid => self.objectid, :object_version => (self.object_version - 1) )
      end
      #logger.info 'end after_create : '+self.objectid
    end

  validates_presence_of :objectid
  validates_uniqueness_of :objectid
  validates_numericality_of :object_version
  validate :objectid_format_compliance

  def objectid_format_compliance
    if !self.objectid.valid?
      #errors.add(:objectid, "is not a valid ObjectId object")
      errors.add(:objectid,I18n.t("activerecord.errors.models.trident.invalid_object_id",:type => self.class.object_id_key))
#    else
#      unless self.objectid.object_type==self.class.object_id_key
#        errors.add(:objectid,I18n.t("activerecord.errors.models.trident.invalid_object_id_type",:type => self.class.object_id_key))
#      end
    end
  end
  
  def uniq_objectid
    i = 0
    baseobjectid = self.objectid
    while self.class.exists?(:objectid => self.objectid) 
      i += 1
      self.objectid = baseobjectid+"_"+i.to_s
    end
  end

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def objectid
    Chouette::ObjectId.new read_attribute(:objectid)
  end

#  def version
#    self.object_version
#  end

#  def version=(version)
#    self.object_version = version
#  end

  before_validation :default_values, :on => :create
  def default_values
    self.object_version ||= 1
  end

  def timestamp_attributes_for_update #:nodoc:
    [:creation_time]
  end
  
  def timestamp_attributes_for_create #:nodoc:
    [:creation_time]
  end

end
