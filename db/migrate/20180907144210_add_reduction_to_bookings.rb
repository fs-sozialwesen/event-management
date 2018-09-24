class AddReductionToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :reduction, :string
  end
end
