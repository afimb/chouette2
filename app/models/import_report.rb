class ImportReport  
  include ReportConcern

  def initialize( response )
    @datas = response.action_report
  end
  
end

