# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  session_token   :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
   subject(:user) do
    FactoryBot.build(:user,
      name: "michael",
      password: "mypassword")
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:session_token) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'uniqueness' do  
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:session_token) }
  end

  describe 'public methods' do

    describe '::find_by_credentials' do
      before { user.save! }
      context 'with valid credentials' do
        it 'should return a correct user' do
          expect(User.find_by_credentials("michael", "mypassword")).to eq(user)
        end
      end
      
      context 'with invalid credentials' do
        it 'should return nil' do
          expect(User.find_by_credentials("invalid", "input")).to eq(nil)
        end
      end

    end

    describe '#is_password?' do

      context 'with correct password' do
        it 'should return true' do
          expect(user.is_password?('mypassword')).to be(true)
        end
      end

      context 'with incorrect password' do
        it 'should return false' do
          expect(user.is_password?('wrong')).to be(false)
        end
      end

    end

    describe '#reset_session_token!' do
      it "should update user's session token" do
        old_session_token = user.session_token
        user.reset_session_token!
        expect(user.session_token).to_not eq(old_session_token)
      end
    end

  end
end
