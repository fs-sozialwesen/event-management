require Rails.root.join 'db', 'migrate', '20180313214840_alchemy_two_point_six.alchemy.rb'
require Rails.root.join 'db', 'migrate', '20180313214851_add_foreign_key_indices_and_null_constraints.alchemy.rb'
require Rails.root.join 'db', 'migrate', '20180313214852_add_foreign_keys.alchemy.rb'

class RemoveAlchemy < ActiveRecord::Migration[5.1]

  def change
    revert AddForeignKeys
    revert AddForeignKeyIndicesAndNullConstraints
    revert AlchemyTwoPointSix
  end

end
