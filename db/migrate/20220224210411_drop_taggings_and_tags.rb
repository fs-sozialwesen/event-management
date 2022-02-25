class DropTaggingsAndTags < ActiveRecord::Migration[5.2]
  def up
    drop_table :taggings
    drop_table :tags
  end
end
