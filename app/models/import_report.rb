class ImportReport
  extend Enumerize
  extend ActiveModel::Naming
  include ActiveModel::Model  

  attr_reader :datas
  
  def initialize( options = Hashie::Mash.new )
    @datas = options
  end

end
