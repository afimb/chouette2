class FileValidationLogMessage < ActiveRecord::Base
  belongs_to :file_validation
  acts_as_list :scope => :file_validation
  
  attr_accessor :children
  
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
 
  def level
    last_key=key.rpartition("|").last
    if last_key == 'TooMuchDetails' 
      4
    else
      last_key.count("_") + 1
    end
  end
 
  def full_message
    last_key=key.rpartition("|").last
    I18n.translate last_key, arguments.symbolize_keys.merge(:scope => "file_validation_log_messages.messages").merge(:default => :undefined).merge(:key => last_key)
  end
  
  def label
    last_key=key.rpartition("|").last
    label = ""
    last_key.split("_").each do |tag|
      if (tag.start_with?("Test")) 
        label = tag.delete("Test")
      else
        label += "."+tag.delete("Sheet").delete("Step")
      end
    end
    label
  end
  
  def add_child(child)
    if self.children.nil?
      self.children = Array.new
    end
    self.children << child
  end

end
