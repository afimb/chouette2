class ExtractBookingArrangementFromFlexibleLineProperties < ActiveRecord::Migration
  def change

    create_table :booking_arrangements, :force => true do |t|
      t.string   "booking_note"
      t.string   "booking_access"
      t.string   "book_when"
      t.time   "latest_booking_time"
      t.time   "minimum_booking_period"
      t.integer   "booking_contact_id"
    end

    create_table :booking_arrangements_buy_when, :id => false, :force => true do |t|
      t.integer  "booking_arrangement_id"
      t.string   "buy_when"
    end
    add_foreign_key "booking_arrangements_buy_when", "booking_arrangements", name: "booking_arrangement_buy_when_lines_fkey"

    create_table :booking_arrangements_booking_methods, :id => false, :force => true do |t|
      t.integer  "booking_arrangement_id"
      t.string   "booking_method"
    end
    add_foreign_key "booking_arrangements_booking_methods", "booking_arrangements", name: "booking_arrangements_booking_methods_lines_fkey"

    add_column :lines, :booking_arrangement_id, :integer, null: true

    add_foreign_key "lines", "booking_arrangements", column: "booking_arrangement_id", name: "lines_booking_arrangement_fkey"
    add_foreign_key "booking_arrangements", "contact_structures", column: "booking_contact_id", name: "booking_arrangement_booking_contact_fkey"


    remove_foreign_key :lines, :booking_contacts
    remove_column :lines, :booking_note, :string, null: true
    remove_column :lines, :booking_access, :string, null: true
    remove_column :lines, :book_when, :string, null: true
    remove_column :lines, :latest_booking_time, :time, null: true
    remove_column :lines, :minimum_booking_period, :time, null: true
    remove_column :lines, :booking_contact_id, :integer, null: true

    drop_table :lines_buy_when;
    drop_table :lines_booking_methods;
  end
end
