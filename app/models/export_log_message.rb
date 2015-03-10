class ExportLogMessage < ActiveRecord::Base
  belongs_to :export

  acts_as_list :scope => :export
  
  validates_presence_of :key
  validates_inclusion_of :severity, :in => %w{info warning error ok uncheck fatal}

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
    begin
      I18n.translate last_key, arguments.symbolize_keys.merge(:scope => "export_log_messages.messages").merge(:default => :undefined).merge(:key => last_key)
    rescue => e
      Rails.logger.error "missing arguments for message "+last_key
      I18n.translate "WRONG_DATA",{"0"=>last_key}.symbolize_keys.merge(:scope => "export_log_messages.messages").merge(:default => :undefined).merge(:key => "WRONG_DATA")
    end
  end
end
