# frozen_string_literal: true

class Payslip < ApplicationRecord
  belongs_to :employee

  after_save :send_payslip_mail

  def send_payslip_mail
    PayslipMailer.with(payslip: self).payslip_email.deliver_now
  end
end
