class NeptuneExport < Export

  option :start_date
  option :end_date
  option :extensions
  
  def export_options
    start_date ||= ""
    end_date ||= ""
    extensions ||= "1"
    if (start_date.empty? && end_date.empty?)
       super.merge(:format => :neptune, :extensions => extensions ).except(:start_date).except(:end_date)
    elsif start_date.empty?
       super.merge(:format => :neptune, :extensions => extensions , :end_date => end_date).except(:start_date)
    elsif end_date.empty?
       super.merge(:format => :neptune, :extensions => extensions , :start_date => start_date).except(:end_date)
    else  
       super.merge(:format => :neptune, :extensions => extensions , :start_date => start_date, :end_date => end_date)
    end
  end

end
