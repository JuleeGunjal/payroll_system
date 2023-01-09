class CreateLeaves < ActiveRecord::Migration[7.0]
  def change
    create_table :leaves do |t|
      t.string :status
      t.date :from_date
      t.date :to_date
      t.text :reason
      t.string :type
      t.references :employee
      t.timestamps
    end
  
  end
end
