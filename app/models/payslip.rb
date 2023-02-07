class Payslip < ApplicationRecord

  belongs_to :employee
     
  after_save :send_payslip_mail

  def send_payslip_mail
    PayslipMailer.with(payslip: self).payslip_email.deliver_now
  end

  def self.search(search)
    if search
      @payslips = Payslip.where(date: search.to_date.end_of_month)
      if @payslips
        @payslips
      else
        @payslips = Payslip.all
      end
    else
      @payslips = Payslip.all
    end
  end

end
