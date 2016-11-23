class Chouette::TimeTable < ApplicationRecord
  include ObjectidRestrictions
  include TimeTableRestrictions
  # FIXME http://jira.codehaus.org/browse/JRUBY-6358
  self.primary_key = "id"

  acts_as_taggable

  attr_accessor :monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday
  attr_accessor :tag_search

  def self.ransackable_attributes auth_object = nil
    (column_names + ['tag_search']) + _ransackers.keys
  end

  has_and_belongs_to_many :vehicle_journeys, :class_name => 'Chouette::VehicleJourney'

  has_many :dates, -> {order(:date)}, inverse_of: :time_table, :validate => :true, :class_name => "Chouette::TimeTableDate", :dependent => :destroy
  has_many :periods, -> {order(:period_start)}, inverse_of: :time_table, :validate => :true, :class_name => "Chouette::TimeTablePeriod", :dependent => :destroy

  after_save :save_shortcuts

  def self.object_id_key
    "Timetable"
  end

  accepts_nested_attributes_for :dates, :allow_destroy => :true
  accepts_nested_attributes_for :periods, :allow_destroy => :true

  validates_presence_of :comment
  validates_associated :dates
  validates_associated :periods

  def presenter
    @presenter ||= ::TimeTablePresenter.new( self)
  end

  def self.start_validity_period
    [Chouette::TimeTable.minimum(:start_date)].compact.min
  end
  def self.end_validity_period
    [Chouette::TimeTable.maximum(:end_date)].compact.max
  end

  def save_shortcuts
      shortcuts_update
      self.update_column(:start_date, start_date)
      self.update_column(:end_date, end_date)
  end

  def shortcuts_update(date=nil)
    dates_array = bounding_dates
    #if new_record?
      if dates_array.empty?
        self.start_date=nil
        self.end_date=nil
      else
        self.start_date=dates_array.min
        self.end_date=dates_array.max
      end
    #else
     # if dates_array.empty?
     #   update_attributes :start_date => nil, :end_date => nil
     # else
     #   update_attributes :start_date => dates_array.min, :end_date => dates_array.max
     # end
    #end
  end

  def validity_out_from_on?(expected_date)
    return false unless self.end_date
    self.end_date <= expected_date
  end
  def validity_out_between?(starting_date, ending_date)
    return false unless self.start_date
    starting_date < self.end_date  &&
      self.end_date <= ending_date
  end
  def self.validity_out_from_on?(expected_date,limit=0)
    if limit==0
      Chouette::TimeTable.where("end_date <= ?", expected_date)
    else
      Chouette::TimeTable.where("end_date <= ?", expected_date).limit( limit)
    end
  end
  def self.validity_out_between?(start_date, end_date,limit=0)
    if limit==0
      Chouette::TimeTable.where( "? < end_date", start_date).where( "end_date <= ?", end_date)
    else
      Chouette::TimeTable.where( "? < end_date", start_date).where( "end_date <= ?", end_date).limit( limit)
    end
  end

  # Return days which intersects with the time table dates and periods
  def intersects(days)
    [].tap do |intersect_days|
      days.each do |day|
        intersect_days << day if include_day?(day)
      end
    end
  end

  def include_day?(day)
    include_in_dates?(day) || include_in_periods?(day)
  end

  def include_in_dates?(day)
    self.dates.any?{ |d| d.date === day && d.in_out == true }
  end

  def excluded_date?(day)
    self.dates.any?{ |d| d.date === day && d.in_out == false }
  end

  def include_in_periods?(day)
    self.periods.any?{ |period| period.period_start <= day &&
                                day <= period.period_end &&
                                valid_days.include?(day.cwday) &&
                                ! excluded_date?(day) }
  end

  def include_in_overlap_dates?(day)
    return false if self.excluded_date?(day)

    counter = self.dates.select{ |d| d.date === day}.size + self.periods.select{ |period| period.period_start <= day && day <= period.period_end && valid_days.include?(day.cwday) }.size
    counter <= 1 ? false : true
   end

  def periods_max_date
    return nil if self.periods.empty?

    min_start = self.periods.map(&:period_start).compact.min
    max_end = self.periods.map(&:period_end).compact.max
    result = nil

    if max_end && min_start
      max_end.downto( min_start) do |date|
        if self.valid_days.include?(date.cwday) && !self.excluded_date?(date)
            result = date
            break
        end
      end
    end
    result
  end
  def periods_min_date
    return nil if self.periods.empty?

    min_start = self.periods.map(&:period_start).compact.min
    max_end = self.periods.map(&:period_end).compact.max
    result = nil

    if max_end && min_start
      min_start.upto(max_end) do |date|
        if self.valid_days.include?(date.cwday) && !self.excluded_date?(date)
            result = date
            break
        end
      end
    end
    result
  end
  def bounding_dates
    bounding_min = self.dates.select{|d| d.in_out}.map(&:date).compact.min
    bounding_max = self.dates.select{|d| d.in_out}.map(&:date).compact.max

    unless self.periods.empty?
      bounding_min = periods_min_date if periods_min_date &&
          (bounding_min.nil? || (periods_min_date < bounding_min))

      bounding_max = periods_max_date if periods_max_date &&
          (bounding_max.nil? || (bounding_max < periods_max_date))
    end

    [bounding_min, bounding_max].compact
  end

  def day_by_mask(flag)
    int_day_types & flag == flag
  end

  def self.day_by_mask(int_day_types,flag)
    int_day_types & flag == flag
  end


  def valid_days
    # Build an array with day of calendar week (1-7, Monday is 1).
    [].tap do |valid_days|
      valid_days << 1  if monday
      valid_days << 2  if tuesday
      valid_days << 3  if wednesday
      valid_days << 4  if thursday
      valid_days << 5  if friday
      valid_days << 6  if saturday
      valid_days << 7  if sunday
    end
  end

  def self.valid_days(int_day_types)
    # Build an array with day of calendar week (1-7, Monday is 1).
    [].tap do |valid_days|
      valid_days << 1  if day_by_mask(int_day_types,4)
      valid_days << 2  if day_by_mask(int_day_types,8)
      valid_days << 3  if day_by_mask(int_day_types,16)
      valid_days << 4  if day_by_mask(int_day_types,32)
      valid_days << 5  if day_by_mask(int_day_types,64)
      valid_days << 6  if day_by_mask(int_day_types,128)
      valid_days << 7  if day_by_mask(int_day_types,256)
    end
  end

  def monday
    day_by_mask(4)
  end
  def tuesday
    day_by_mask(8)
  end
  def wednesday
    day_by_mask(16)
  end
  def thursday
    day_by_mask(32)
  end
  def friday
    day_by_mask(64)
  end
  def saturday
    day_by_mask(128)
  end
  def sunday
    day_by_mask(256)
  end

  def set_day(day,flag)
    if day == '1' || day == true
      self.int_day_types |= flag
    else
      self.int_day_types &= ~flag
    end
    shortcuts_update
  end

  def monday=(day)
    set_day(day,4)
  end
  def tuesday=(day)
    set_day(day,8)
  end
  def wednesday=(day)
    set_day(day,16)
  end
  def thursday=(day)
    set_day(day,32)
  end
  def friday=(day)
    set_day(day,64)
  end
  def saturday=(day)
    set_day(day,128)
  end
  def sunday=(day)
    set_day(day,256)
  end

  def effective_days_of_period(period,valid_days=self.valid_days)
    days = []
      period.period_start.upto(period.period_end) do |date|
        if valid_days.include?(date.cwday) && !self.excluded_date?(date)
            days << date
        end
      end
    days
  end

  def effective_days(valid_days=self.valid_days)
    days=self.effective_days_of_periods(valid_days)
    self.dates.each do |d|
      days |= [d.date] if d.in_out
    end
    days.sort
  end

  def effective_days_of_periods(valid_days=self.valid_days)
    days = []
    self.periods.each { |p| days |= self.effective_days_of_period(p,valid_days)}
    days.sort
  end

  def clone_periods
    periods = []
    self.periods.each { |p| periods << p.copy}
    periods
  end

  def included_days
    days = []
    self.dates.each do |d|
      days |= [d.date] if d.in_out
    end
    days.sort
  end

  def excluded_days
    days = []
    self.dates.each do |d|
      days |= [d.date] unless d.in_out
    end
    days.sort
  end


  # produce a copy of periods without anyone overlapping or including another
  def optimize_periods
    periods = self.clone_periods
    optimized = []
    i=0
    while i < periods.length
      p1 = periods[i]
      optimized << p1
      j= i+1
      while j < periods.length
        p2 = periods[j]
        if p1.contains? p2
          periods.delete p2
        elsif p1.overlap? p2
          p1.period_start = [p1.period_start,p2.period_start].min
          p1.period_end = [p1.period_end,p2.period_end].max
          periods.delete p2
        else
          j += 1
        end
      end
      i+= 1
    end
    optimized.sort { |a,b| a.period_start <=> b.period_start}
  end

  # add a peculiar day or switch it from excluded to included
  def add_included_day(d)
    if self.excluded_date?(d)
       self.dates.each do |date|
         if date.date === d
           date.in_out = true
         end
       end
    elsif !self.include_in_dates?(d)
       self.dates << Chouette::TimeTableDate.new(:date => d, :in_out => true)
    end
  end

  # merge effective days from another timetable
  def merge!(another_tt)
    transaction do
    # if one tt has no period, just merge lists
    if self.periods.empty? || another_tt.periods.empty?
      if !another_tt.periods.empty?
        # copy periods
        self.periods = another_tt.clone_periods
        # set valid_days
        self.int_day_types = another_tt.int_day_types
      end
      # merge dates
      self.dates ||= []
      another_tt.included_days.each do |d|
        add_included_day d
      end
    else
      # check if periods can be kept
      common_day_types = self.int_day_types & another_tt.int_day_types & 508
      # if common day types : merge periods
      if common_day_types != 0
        periods = self.optimize_periods
        another_periods = another_tt.optimize_periods
        # add not common days of both periods as peculiar days
        self.effective_days_of_periods(self.class.valid_days(self.int_day_types ^ common_day_types)).each do |d|
          self.dates |= [Chouette::TimeTableDate.new(:date => d, :in_out => true)]
        end
        another_tt.effective_days_of_periods(self.class.valid_days(another_tt.int_day_types ^ common_day_types)).each do |d|
          add_included_day d
        end
        # merge periods
        self.periods = periods | another_periods
        self.int_day_types = common_day_types
        self.periods = self.optimize_periods
      else
        # convert all period in days
        self.effective_days_of_periods.each do |d|
          self.dates << Chouette::TimeTableDate.new(:date => d, :in_out => true) unless self.include_in_dates?(d)
        end
        another_tt.effective_days_of_periods.each do |d|
          add_included_day d
        end
      end
    end
    # if remained excluded dates are valid in other tt , remove it from result
    self.dates.each do |date|
      date.in_out = true if date.in_out == false && another_tt.include_day?(date.date)
    end

    # if peculiar dates are valid in new periods, remove them
    if !self.periods.empty?
      days_in_period = self.effective_days_of_periods
      dates = []
      self.dates.each do |date|
        dates << date unless date.in_out && days_in_period.include?(date.date)
      end
      self.dates = dates
    end
    self.dates.to_a.sort! { |a,b| a.date <=> b.date}
    self.save!
    end
  end

  # remove dates form tt which aren't in another_tt
  def intersect!(another_tt)
    transaction do

      # transform tt as effective dates and get common ones
      days = another_tt.intersects(self.effective_days) & self.intersects(another_tt.effective_days)
      self.dates.clear
      days.each {|d| self.dates << Chouette::TimeTableDate.new( :date =>d, :in_out => true)}
      self.periods.clear
      self.int_day_types = 0
      self.dates.to_a.sort! { |a,b| a.date <=> b.date}
      self.save!
    end
  end


  def disjoin!(another_tt)
    transaction do
      # remove days from another calendar
      days_to_exclude = self.intersects(another_tt.effective_days)
      days = self.effective_days - days_to_exclude
      self.dates.clear
      self.periods.clear
      self.int_day_types = 0

      days.each {|d| self.dates << Chouette::TimeTableDate.new( :date =>d, :in_out => true)}

      self.dates.to_a.sort! { |a,b| a.date <=> b.date}
      self.periods.to_a.sort! { |a,b| a.period_start <=> b.period_start}
      self.save!
    end
  end

  def duplicate
    tt = self.deep_clone :include => [:periods, :dates], :except => :object_version
    # tt.uniq_objectid
    tt.comment = I18n.t("activerecord.copy", :name => self.comment)
    tt
  end
end

