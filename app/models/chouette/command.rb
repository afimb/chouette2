require 'tmpdir'

#if RUBY_PLATFORM == "java"
  # FIXME disable remove_entry_secure because incompatible with jruby ?! 
  # See http://jira.codehaus.org/browse/JRUBY-4082
  module FileUtils
    def self.remove_entry_secure(*args)
      self.remove_entry *args
    end
  end
#end

class Chouette::Command

  include Chouette::CommandLineSupport

  @@command = "chouette"
  cattr_accessor :command

  attr_accessor :database, :schema, :host, :user, :password, :port

  def initialize(options = {})
    database_options_from_active_record.merge(options).each do |k,v|
      send "#{k}=", v
    end
  end

  def database_options_from_active_record
    config = Chouette::ActiveRecord.connection_pool.spec.config
    { 
      :database => config[:database], 
      :user => config[:username],
      :password => config[:password],
      :port => config[:port],
      :host => (config[:host] or "localhost")
    }
  end


  def run!(options = {})
    Dir.mktmpdir do |config_dir|
      chouette_properties = File.join(config_dir, "chouette.properties")
      open(chouette_properties, "w") do |f|
        f.puts "database.name = #{database}"
        f.puts "database.schema = #{schema}"
        #f.puts "database.showsql = true"
        f.puts "hibernate.username = #{user}"
        f.puts "hibernate.password = #{password}"
        f.puts "jdbc.url=jdbc:postgresql://#{host}:#{port}/#{database}"
        f.puts "jdbc.username = #{user}"
        f.puts "jdbc.password = #{password}"
        #f.puts "database.hbm2ddl.auto=update"
      end

      logger.debug "Chouette properties: #{File.readlines(chouette_properties).collect(&:strip).join(', ')}"

      command_line = "#{command} -classpath #{config_dir} #{command_options(options)}"
      logger.debug "Execute '#{command_line}'"

      execute! command_line
    end
  end

  class Option

    attr_accessor :key, :value

    def initialize(key, value)
      @key, @value = key.to_s, value
    end

    def command_key
      key.camelize(:lower) 
    end

    def to_s
      unless value == true
        "-#{command_key} #{value}"
      else
        "-#{command_key}"
      end
    end

  end

  def command_options(options)
    options.collect do |key, value|
      Option.new(key, value)
    end.sort_by(&:key).join(' ')
  end

  

end
