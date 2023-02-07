class AddColumnYearInTaxDeduction < ActiveRecord::Migration[7.0]
  def change
    add_column :tax_deductions, :financial_year, :string
  end
end
