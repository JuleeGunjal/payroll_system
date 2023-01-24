module TaxDeductionsHelper
  def get_name(tax_deduction)
    Employee.find(tax_deduction.employee_id).first_name
  end
end
