class TimebandPresenter

  def initialize(timeband)
    @timeband = timeband
  end

  def title
    if @timeband.name.blank?
      "#{I18n.l(@timeband.start_time, format: :hour)}-#{I18n.l(@timeband.end_time, format: :hour)}"
    else
      @timeband.name
    end
  end

end
