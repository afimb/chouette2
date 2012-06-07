class ExportLogMessage < ActiveRecord::Base
  belongs_to :export

  acts_as_list :scope => :export
  
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
    I18n.translate key, arguments.symbolize_keys.merge(:scope => "export_log_messages.messages")
  end
end
