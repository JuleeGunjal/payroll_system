class Employee < User

  validates :first_name, presence: true
  has_many :leaves, dependent: :destroy, class_name: "Leave"
  
end
