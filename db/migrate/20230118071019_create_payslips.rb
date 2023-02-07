class CreatePayslips < ActiveRecord::Migration[7.0]
  def change
    create_table :payslips do |t|
      t.integer :taxable_income
      t.integer :payable_salary
      t.date :date
      t.references :employee
      t.timestamps
    end
  end
end
