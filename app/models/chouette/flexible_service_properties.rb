class Chouette::FlexibleServiceProperties < Chouette::ActiveRecord
  belongs_to :booking_arrangement, :class_name => 'Chouette::BookingArrangement', :dependent => :destroy
  accepts_nested_attributes_for :booking_arrangement, :allow_destroy => :true

end
