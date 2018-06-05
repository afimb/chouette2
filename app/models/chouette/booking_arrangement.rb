class Chouette::BookingArrangement < Chouette::ActiveRecord
  belongs_to :booking_contact, :class_name => 'Chouette::ContactStructure', :dependent => :destroy
  accepts_nested_attributes_for :booking_contact, :allow_destroy => :true

  has_many :buy_when_objects, :class_name => 'Chouette::BookingArrangementsBuyWhen', :autosave => true, :dependent => :delete_all
  has_many :booking_method_objects, :class_name => 'Chouette::BookingArrangementsBookingMethod', :autosave => true, :dependent => :delete_all

  def buy_when
    buy_when_objects.map {|bw| bw.buy_when}
  end

  def buy_when=(string_values)
    buy_when_objects.clear
    buy_when_objects << string_values.reject(&:blank?).collect {|bw| babw= Chouette::BookingArrangementsBuyWhen.new(); babw.booking_arrangement=self; babw.buy_when=bw; babw}
  end

  def booking_methods
    booking_method_objects.map {|bw| bw.booking_method}
  end


  def booking_methods=(string_values)
    booking_method_objects.clear
    booking_method_objects << string_values.reject(&:blank?).collect {|bm| babm= Chouette::BookingArrangementsBookingMethod.new(); babm.booking_arrangement=self; babm.booking_method=bm; babm}
  end


  @booking_method_types = nil
  def self.booking_method_types
    @booking_method_types ||= Chouette::BookingMethodType.all.select do |booking_method|
      booking_method.to_i > -1
    end
  end

  @booking_access_types = nil
  def self.booking_access_types
    @booking_access_types ||= Chouette::BookingAccessType.all.select do |booking_access|
      booking_access.to_i > -1
    end
  end

  @purchase_moment_types = nil
  def self.purchase_moment_types
    @purchase_moment_types ||= Chouette::PurchaseMomentType.all.select do |purchase_moment|
      purchase_moment.to_i > -1
    end
  end

  @purchase_when_types = nil
  def self.purchase_when_types
    @@purchase_when_types ||= Chouette::PurchaseWhenType.all.select do |purchase_when|
      purchase_when.to_i > -1
    end
  end

end
