class Chouette::TimeTablePeriod < Chouette::ActiveRecord
  self.primary_key = "id"
  belongs_to :time_table, inverse_of: :periods
  acts_as_list :scope => 'time_table_id = #{time_table_id}',:top_of_list => 0

  validates_presence_of :period_start
  validates_presence_of :period_end
  
  validate :start_must_be_before_end

  
  def self.model_name
    ActiveModel::Name.new Chouette::TimeTablePeriod, Chouette, "TimeTablePeriod"
  end
  
  def start_must_be_before_end
    # security against nil values
    if period_end.nil? || period_start.nil?
      return
    end
    if period_end <= period_start
      errors.add(:period_end,I18n.t("activerecord.errors.models.time_table_period.start_must_be_before_end"))
    end
  end
    
  def copy
    Chouette::TimeTablePeriod.new(:period_start => self.period_start,:period_end => self.period_end)
  end
  
  # Test to see if a period overlap this period
  def overlap?(p)
     (p.period_start >= self.period_start && p.period_start <= self.period_end) || (p.period_end >= self.period_start && p.period_end <= self.period_end)
  end

  # Test to see if a period is included in this period
  def contains?(p)
     (p.period_start >= self.period_start && p.period_end <= self.period_end)
  end
  
end
