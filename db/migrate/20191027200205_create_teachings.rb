class CreateTeachings < ActiveRecord::Migration[5.1]
  def change
    create_table :teachings do |t|
      t.references :seminar, foreign_key: true
      t.references :teacher, foreign_key: true
      t.integer :position, default: 1

      t.timestamps
    end

    add_index :teachings, [:seminar_id, :teacher_id], unique: true
  end
end
