require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  context "POST /users/sign_in " do
   
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create , params: {
        user: {
          email: "dummy@gamil.com",
          password: "Josh@123"
        }  
      }
    end
    it "should sign in with valid credintials" do
      binding.pry
      expect(response.status).to eq(302) 
    end
  end

  context "DELETE /users/sign_out" do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end
    it "should sign out the user" do
      delete :destroy
      expect(response.status).to eq(302)
    end
  end
end