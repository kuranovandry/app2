require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create(:user) }
  
  describe 'GET #index' do
    it "assigns users" do
      get :index, format: :json
      expect(assigns(:users)).to eq([user])
    end

    it "renders the index template" do
      get :index, format: :json
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, format: :json, id: user
      expect(response).to render_template("show")
    end
  end
end
