class AddIsCompanyToBookings < ActiveRecord::Migration[5.1]

  def change
    add_column :bookings, :is_company, :boolean
    add_column :attendees, :is_company, :boolean
  end

end
