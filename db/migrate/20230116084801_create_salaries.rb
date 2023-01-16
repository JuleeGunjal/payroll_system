class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries do |t|
      t.string :date
      t.integer :total_salary
      t.references :employee
      t.timestamps
    end
  end
end
