module ControllerMacros

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryBot.create(:user, type: 'Admin')
    end
  end

  def sign_in
     # Before each test, create and login the user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:employee]
      sign_in FactoryBot.create(:employee)
    end 
  end
  
end
  