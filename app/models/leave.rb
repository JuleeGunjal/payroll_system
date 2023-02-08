# frozen_string_literal: true

class Leave < ApplicationRecord
  validates :status, presence: true
  validates :from_date, :to_date, :reason, :employee_id, :leave_type, presence: true

  belongs_to :employee
end
