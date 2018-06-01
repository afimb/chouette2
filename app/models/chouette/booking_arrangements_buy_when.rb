class Chouette::BookingArrangementsBuyWhen < ActiveRecord::Base
  self.table_name = "booking_arrangements_buy_when"

  belongs_to :booking_arrangement, :class_name => 'Chouette::BookingArrangement'
  validates_presence_of :buy_when
  validates :booking_arrangement_id, presence: true

end