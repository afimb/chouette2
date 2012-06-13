class ImportLogMessage < ActiveRecord::Base
  belongs_to :import
  acts_as_list :scope => :import
  
  validates_presence_of :key
  validates_inclusion_of :severity, :in => %w{info warning error}

  def arguments=(arguments)
    write_attribute :arguments, (arguments.to_json if arguments.present?)
  end

  def arguments
    @decoded_arguments ||= 
      begin
        if (stored_arguments = raw_attributes).present?
          ActiveSupport::JSON.decode stored_arguments
        else
          {}
        end
      end
  end

  def raw_attributes
    read_attribute(:arguments)
  end

  before_validation :define_default_attributes, :on => :create
  def define_default_attributes
    self.severity ||= "info"
  end
 
  def full_message
    last_key=key.rpartition("|").last
    I18n.translate last_key, arguments.symbolize_keys.merge(:scope => "import_log_messages.messages").merge(:default => :undefined).merge(:key => last_key)
  end

end
