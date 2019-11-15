class AddTimestampsToSeminarsTeachers < ActiveRecord::Migration[5.1]
  def change
    change_table :seminars_teachers do |t|
      t.datetime :created_at #, default: 'NOW()'
    end
  end
end
