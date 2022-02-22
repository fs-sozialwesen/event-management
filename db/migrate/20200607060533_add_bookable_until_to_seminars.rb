class AddBookableUntilToSeminars < ActiveRecord::Migration[5.1]
  def change
    add_column :seminars, :bookable_until, :date
  end
end
