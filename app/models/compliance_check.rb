class ComplianceCheck
  extend Enumerize
  extend ActiveModel::Naming
  include ActiveModel::Model

  enumerize :severity, %w{ WARNING ERROR IMPROVMENT }
  enumerize :status, %w{ OK NOK UNCHECK }

  attr_reader :datas, :errors, :metadatas
  
  def initialize( response )
    @datas = response.datas
    @errors = response.errors
    @metadatas = response.metadatas
  end

  def import
    report_path = metadatas.find {|metatadata| "#{metadata.rel}" == "location" }
    response = IevApi.request(:get, report_path, params)
    Import.new(response)
  end 

  def warning
    datas.tests.select{ |test| test[:severity] == "WARNING"}
  end
  
  def error
    datas.tests.select{ |test| test[:severity] == "ERROR"}
  end
  
  def improvment
    datas.tests.select{ |test| test[:severity] == "IMPROVMENT"}
  end

  def ok
    datas.tests.select{ |test| test[:result] == "OK"}
  end
  
  def nok
    datas.tests.select{ |test| test[:result] == "NOK"}
  end
  
  def uncheck
    datas.tests.select{ |test| test[:result] == "UNCHECK"}
  end
  
end
