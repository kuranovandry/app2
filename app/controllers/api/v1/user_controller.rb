class Api::V1::UsersController < Api::V1::ApplicationController
  before_filter :get_user, except: [:index, :create]
  respond_to :html, :json

  def index
    @user = User.all
    respond_with(@users) do |format|
      format.json { render json: @user.as_json }
      format.html
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.as_json, status: :ok
    else
      render json: {user: @user.errors, status: :no_content}
    end
  end      

  def show
    respond_with(@user.as_json)
  end

  def update
    if @user.update_attributes(user_params)
      render json: @user.as_json, status: :ok 
    else
      render json: {user: @user.errors, status: :unprocessable_entity}
    end
  end

  def destroy
    @user.destroy
    render json: {status: :ok}
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, 
                                   :addresses_attributes => [:id, :street1, :street2, :city, :state, :country, :zipcode, :_destroy, :user_id])
  end

  def get_user
    @user = User.find(params[:id])
  end
end
#TODO: create jbuilder partial for users
#TODO: use same partial for index, show and other methods
#TODO: apply same api errors rendering as on colaborator
#TODO: install bootstrap sass gem that supports rails 4.2
#TODO: install rspec and add basic unit tests (validations, methods tests) - see shoulda-matchers gem
#TODO: read heroku documentation for rails apps, install necessary gems and deploy to heroku
