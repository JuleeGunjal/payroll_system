# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attendance, type: :model do
  context 'when creating attendance ' do
    let(:attendance) { build :attendance }
    let(:attendance1) { build :attendance, month: '' }
    it 'should be valid attendance with valid parameters' do     
      expect(attendance.valid?).to eq(true)
    end
    it 'should not valid attendance with invalid parameters' do
      expect(attendance1.valid?).to eq(false)
    end
  end
end
