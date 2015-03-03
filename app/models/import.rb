class Import
  extend Enumerize
  extend ActiveModel::Naming
  include ActiveModel::Model  
  
  enumerize :status, in: %w{created scheduled terminated canceled aborted}, default: "created", predicates: true
  enumerize :format, in: %w{neptune netex gtfs}, default: "neptune", predicates: true

  attr_reader :datas, :report
  
  def initialize( options = Hashie::Mash.new )
    puts "options #{options.inspect}"
    @datas = options
    @status = @datas.status.downcase if @datas.status?
    @format = @datas.type.downcase if @datas.type?
  end

  def report
    ImportReport.new( IevApi.job(referential_name, id,{ :action => "importer" }) )
  end

  def id
    @datas.id
  end

  def percentage_progress
    if %w{created}.include? status
      0
    elsif %w{ terminated canceled aborted }.include? status
      100
    else
      20
    end
  end

  def links
    @datas.links
  end

  def referential_name
    @datas.parameters.referential
  end
  
  def name
    @datas.parameters.name
  end

  def user_name?
    @datas.parameters? && @datas.parameters.user_name?
  end
  
  def user_name
    @datas.parameters.user_name if user_name?
  end

  def no_save
    @datas.parameters.no_save
  end

  def filename
    @datas.filename
  end

  def created_at?
    @datas.created?
  end
  
  def created_at
    Time.at(@datas.created.to_i / 1000) if created_at?
  end

  def updated_at?
    @datas.updated?
  end

  def updated_at
    Time.at(@datas.updated.to_i / 1000) if updated_at?
  end

end
