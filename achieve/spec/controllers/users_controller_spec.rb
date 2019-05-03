require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #new' do
    it 'brings up form to create new user' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { user: { name: 'michael',  password: 'password' } } }
    let(:invalid_params) { { user: { name: 'michael', hungry: 'yes' } } }

    context 'with valid params' do
      before(:each) do
        post :create, params: valid_params
      end
      
      it 'creates new user' do
        expect(User.last.name).to eq('michael')
      end
      
      it "redirects to user's goals" do
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_url)
      end

    end
    
    context 'with invalid params' do
      before(:each) do
        post :create, params: invalid_params
      end

      it 're-renders new user form' do
        expect(response).to render_template(:new)
      end

      it 'adds errors to the flash errors cookie' do
        expect(flash[:errors]).to be_present
      end

    end

  end

end

