class NeptuneExport < Export

  option :start_date
  option :end_date
  
  def export_options
    if (start_date.empty? && end_date.empty?)
       super.merge(:format => :neptune).except(:start_date).except(:end_date)
    elsif start_date.empty?
       super.merge(:format => :neptune, :end_date => end_date).except(:start_date)
    elsif end_date.empty?
       super.merge(:format => :neptune, :start_date => start_date).except(:end_date)
    else  
       super.merge(:format => :neptune, :start_date => start_date, :end_date => end_date)
    end
  end

end
