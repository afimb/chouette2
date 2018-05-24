class Chouette::LinesBookingMethod < ActiveRecord::Base
  belongs_to :line, :class_name => 'Chouette::Line'
  validates_presence_of :booking_method
  validates :line_id, presence: true

end