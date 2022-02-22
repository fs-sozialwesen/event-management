class SetBookableUntilToSeminars < ActiveRecord::Migration[5.1]
  def up
    execute "UPDATE seminars set bookable_until = date"
  end
end
