class AddMoreReductionsToSeminars < ActiveRecord::Migration[5.1]

  def change
    change_table :seminars do |t|
      t.boolean :group_reducible, default: true
      t.boolean :school_reducible, default: true
    end
  end

end
