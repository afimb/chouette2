class Chouette::BookingArrangementsBookingMethod < ActiveRecord::Base
  belongs_to :booking_arrangement, :class_name => 'Chouette::BookingArrangement'
  validates_presence_of :booking_method
  validates :booking_arrangement, presence: true

end