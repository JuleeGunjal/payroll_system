# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Employee, type: :model do
  
  describe 'employee validations' do
    before do 
      @dummy = build(:employee)
     end
    
    context 'credentials' do
      
      it 'should contain email with specified pattern' do
        binding.pry
        expect(@dummy.email).to match(EMAIL_REGEX)
      end

      it 'should contain unique email' do
        @dummy2 = build(:employee)
        @dummy2.email = @dummy.email
        @dummy2.save
        expect(@dummy2.reload.email).not_to be @dummy.email
      end

      it 'should contain password with pattern' do
        expect(@dummy.password).to match(PASSWORD_REGEX)
      end
    end

    context 'presence of credentials' do

      it 'should contain email' do
        expect(@dummy.errors.full_messages.join(', ')).not_to be(I18n.t('blank').to_s)
      end

      it 'should contain email' do
        @dummy.email = nil
        @dummy.save
        expect(@dummy.errors.full_messages.join(', ')).not_to be(I18n.t('blank').to_s + " , #{I18n.t('invalid')}")
      end

      it 'should contain first name' do
        expect(@dummy.first_name).not_to be(I18n.t('blank').to_s)
      end

      it 'should contain gender' do
        expect(@dummy.gender).not_to be_blank
      end
    end
  end
end
