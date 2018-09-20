class AddReductionsToSeminars < ActiveRecord::Migration[5.1]

  def change
    change_table :seminars do |t|
      t.boolean :tandem_reducible, default: false
      t.boolean :pari_reducible, default: false
    end
  end

end
