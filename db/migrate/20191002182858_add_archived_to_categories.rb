class AddArchivedToCategories < ActiveRecord::Migration[5.1]
  def change
    change_table :categories do |t|
      t.boolean :archived, default: false, index: true
    end
  end
end
