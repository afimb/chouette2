module Chouette::CommandLineSupport

  class ExecutionError < StandardError; end

  def available_loggers
    [].tap do |logger|
      logger << ::ApplicationRecord.logger
      logger << Rails.logger if defined?(Rails)
      logger << Logger.new($stdout)
    end.compact
  end

  def logger
    @logger ||= available_loggers.first
  end

  def max_output_length
    2000
  end

  def execute!(command)
    logger.debug "execute '#{command}'"

    output = `#{command} 2>&1`
    output = "[...] #{output[-max_output_length,max_output_length]}" if output.length > max_output_length
    logger.info output unless output.empty?

    if $? != 0
      raise ExecutionError.new("Command failed: #{command} (error code #{$?})")
    end

    true
  end

end
