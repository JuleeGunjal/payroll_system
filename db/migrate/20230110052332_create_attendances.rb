class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.integer :month
      t.integer :working_days
      t.string :unpaid_leaves
      t.references :employee
      
      t.timestamps
    end
  end
end
