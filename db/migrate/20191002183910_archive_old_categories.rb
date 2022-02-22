class ArchiveOldCategories < ActiveRecord::Migration[5.1]
  def up
    Category.where('year < 2020').update_all archived: true
  end
end
