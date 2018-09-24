class AddReductionToAttendees < ActiveRecord::Migration[5.1]
  def change
    add_column :attendees, :reduction, :string
  end
end
