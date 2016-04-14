class Chouette::Exporter

  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  def chouette_command
    @chouette_command ||= Chouette::Command.new(:schema => schema)
  end

  def export(file, options = {})
    options = {
      :format => :neptune
    }.merge(options)

    command_options = {
      :c => "export", 
      :o => "line", 
      :format => options.delete(:format).to_s.upcase, 
      :output_file => File.expand_path(file), 
      :optimize_memory => true
    }.merge(options)

    logger.info "Export #{file} in schema #{schema}"
    chouette_command.run! command_options
  end

  include Chouette::CommandLineSupport

end
