class AddRecommendedToSeminars < ActiveRecord::Migration[5.1]

  def change
    change_table :seminars do |t|
      t.boolean :recommended, default: false
      t.string :recommendation_label
    end
  end

end
