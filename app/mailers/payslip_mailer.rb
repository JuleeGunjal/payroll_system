# frozen_string_literal: true

class PayslipMailer < ApplicationMailer
  def payslip_email
    @payslip = params[:payslip]
    @url = 'http://localhost:3000/users/sign_in'
    mail(to: @payslip.employee.email, subject: "Payslip of the month #{Date::MONTHNAMES[@payslip.date.month]}")
  end
end
