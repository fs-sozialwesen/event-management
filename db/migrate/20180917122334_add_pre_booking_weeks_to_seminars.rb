class AddPreBookingWeeksToSeminars < ActiveRecord::Migration[5.1]
  def change
    add_column :seminars, :pre_booking_weeks, :integer, default: 0
  end
end
