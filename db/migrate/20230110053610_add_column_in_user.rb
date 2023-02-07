class AddColumnInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :paid_leaves, :integer, default: 4
  end
end
