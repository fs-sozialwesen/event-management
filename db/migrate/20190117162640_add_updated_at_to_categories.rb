class AddUpdatedAtToCategories < ActiveRecord::Migration[5.1]

  def change
    change_table :categories do |t|
      t.timestamps null: true
    end
  end

end
