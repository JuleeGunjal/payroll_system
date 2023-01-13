class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         validates :email, presence: { message: I18n.t("blank") }, uniqueness: { message: I18n.t("unique") }, format: { with: EMAIL_REGEX, message: I18n.t("invalid")}
         validates :password, confirmation: true

  def admin?
    type == 'Admin'
  end
  
  def employee?
    type == 'Employee'
  end

end
