class CreateTaxDeductions < ActiveRecord::Migration[7.0]
  def change
    create_table :tax_deductions do |t|
      t.string :tax_type
      t.integer :ammount
      t.references :employee
      
      t.timestamps
    end
  end
end
