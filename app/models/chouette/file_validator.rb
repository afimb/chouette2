class Chouette::FileValidator

  attr_reader :schema, :database, :user, :password, :host

  def initialize(schema)
    @schema = schema

    Chouette::ActiveRecord.connection_pool.spec.config.tap do |config|
      @database = config[:database]
      @user = config[:username]
      @password = config[:password]
      @host = (config[:host] or "localhost")
    end
  end

  def self.chouette_command=(command)
    Chouette::Command.command = command
  end

  class << self
    deprecate :chouette_command= => "Use Chouette::Command.command ="
  end

  def chouette_command
    @chouette_command ||= Chouette::Command.new(:schema => schema)
  end

  def validate(file, options = {})
    options = {
      :format => :neptune
    }.merge(options)

    command_options = {
      :c => "validate", 
      :o => "line", 
      :input_file => File.expand_path(file), 
      :optimize_memory => true
    }.merge(options)

    logger.info "Validate #{file}"
    chouette_command.run! command_options
  end


  include Chouette::CommandLineSupport

end
