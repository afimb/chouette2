class Chouette::LinesBuyWhen < ActiveRecord::Base
  self.table_name = "lines_buy_when"

  belongs_to :line, :class_name => 'Chouette::Line'
  validates_presence_of :buy_when
  validates :line_id, presence: true

end