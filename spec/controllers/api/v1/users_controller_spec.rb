require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    let!(:user) { create(:user) }

    it 'assigns users' do
      get :index, format: :json
      expect(assigns(:users)).to eq([user])
    end

    it 'renders the index template' do
      get :index, format: :json
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    it 'renders the show template' do
      get :show, format: :json, id: user
      expect(json_response).to eq({
                                    'id' => user[:id],
                                    'first_name' => user[:first_name],
                                    'last_name' => user[:last_name],
                                    'email' => user[:email]
                                  })
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { {first_name: 'assas', last_name: 'aassa', email: 'as@asas.co'} }

    it 'creates new user' do
      post :create, user: valid_attributes, format: :json
      expect(json_response).to eq({
                                    'id'=> user[:id],
                                    'first_name' => valid_attributes[:first_name],
                                    'last_name' => valid_attributes[:last_name],
                                    'email' => valid_attributes[:email]
                                  })
    end

    context 'with valid attributes' do
      it 'creates a user' do
        expect do
          post :create, user: attributes_for(:user), format: :json
        end.to change(User, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a user' do
        expect {
          post :create, user: {email: nil}
        }.to change(User, :count).by(0)
      end
    end
  end

end
