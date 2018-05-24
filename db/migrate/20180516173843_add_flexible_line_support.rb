class AddFlexibleLineSupport < ActiveRecord::Migration
  def change


    create_table :lines_buy_when, :id => false, :force => true do |t|
      t.integer  "line_id"
      t.string   "buy_when"
    end
    add_foreign_key "lines_buy_when", "lines", name: "lines_buy_when_lines_fkey"

    create_table :lines_booking_methods, :id => false, :force => true do |t|
      t.integer  "line_id"
      t.string   "booking_method"
    end
    add_foreign_key "lines_booking_methods", "lines", name: "lines_booking_methods_lines_fkey"

    create_table :contact_structures, :force => true do |t|
      t.string   "contact_person"
      t.string   "email"
      t.string   "phone"
      t.string   "fax"
      t.string   "url"
      t.string   "further_details"
    end

    add_column :lines, :booking_note, :string, null: true
    add_column :lines, :flexible_line_type, :string, null: true
    add_column :lines, :booking_access, :string, null: true
    add_column :lines, :book_when, :string, null: true
    add_column :lines, :latest_booking_time, :time, null: true
    add_column :lines, :minimum_booking_period, :time, null: true
    add_column :lines, :booking_contact_id, :integer, null: true

    add_foreign_key "lines", "contact_structures", column: "booking_contact_id", name: "lines_booking_contact_fkey"

  end
end
