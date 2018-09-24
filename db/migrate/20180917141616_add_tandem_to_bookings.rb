class AddTandemToBookings < ActiveRecord::Migration[5.1]
  def change
    change_table :bookings do |t|
      t.string :tandem_name
      t.string :tandem_company
      t.string :tandem_address
    end
    change_table :attendees do |t|
      t.string :tandem_name
      t.string :tandem_company
      t.string :tandem_address
    end
  end
end
