class Leave < ApplicationRecord

  validates :status, presence: true
 
  belongs_to :employee
end

