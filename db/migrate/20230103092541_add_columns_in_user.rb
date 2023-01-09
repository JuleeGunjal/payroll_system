class AddColumnsInUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :mobile_number, :string
    add_column :users, :date_of_joining, :date
    add_column :users, :address, :text
    add_column :users, :type, :string
  end
end
