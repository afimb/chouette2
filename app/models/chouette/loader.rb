class Chouette::Loader

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

  # Load dump where datas are in schema 'chouette'
  def load_dump(file)
    logger.info "Load #{file} in schema #{schema}"
    with_pg_password do
      execute!("sed -e 's/ chouette/ \"#{schema}\"/' -e 's/ OWNER TO .*;/ OWNER TO #{user};/' #{file} | psql #{pg_options} --set ON_ERROR_ROLLBACK=1 --set ON_ERROR_STOP=1")
    end
    self
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

  def import(file, options = {})
    options = {
      :format => :neptune
    }.merge(options)

    command_options = {
      :c => "import", 
      :o => "line", 
      :format => options.delete(:format).to_s.upcase, 
      :input_file => File.expand_path(file), 
      :optimize_memory => true
    }.merge(options)

    logger.info "Import #{file} in schema #{schema}"
    chouette_command.run! command_options
  end

  def backup(file)
    logger.info "Backup schema #{schema} in #{file}"

    with_pg_password do
      execute!("pg_dump -n #{schema} -f #{file} #{pg_options}")
    end

    self
  end

  def pg_options
    [].tap do |options|
      options << "-U #{user}" if user
      options << "-h #{host}" if host
      options << database
    end.join(" ")
  end

  def create
    logger.info "Create schema #{schema}"
    with_pg_password do
      execute!("psql -c 'CREATE SCHEMA \"#{schema}\";' #{pg_options}")
    end
    self
  end

  def drop
    logger.info "Drop schema #{schema}"
    with_pg_password do
      execute!("psql -c 'DROP SCHEMA \"#{schema}\" CASCADE;' #{pg_options}")
    end
    self
  end

  def with_pg_password(&block)
    ENV['PGPASSWORD'] = password.to_s if password
    begin
      yield
    ensure
      ENV['PGPASSWORD'] = nil
    end
  end

  @@binarisation_command = "binarisation"
  cattr_accessor :binarisation_command

  def binarize(period, target_directory)
    # TODO check these computed daybefore/dayafter
    day_before = Date.today - period.begin
    day_after = period.end - period.begin

    execute! "#{binarisation_command} --host=#{host} --dbname=#{database} --user=#{user} --password=#{password} --schema=#{schema} --daybefore=#{day_before} --dayafter=#{day_after} --targetdirectory=#{target_directory}"
  end

  include Chouette::CommandLineSupport

end
