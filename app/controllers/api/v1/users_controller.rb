class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :get_user, except: [:index, :create]
  protect_from_forgery

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    @user.save!
  end

  def update
    @user.update_attributes(user_params)
  end

  def destroy
    @user.destroy
    render json: {status: :ok}
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone)
  end

  def get_user
    @user = User.find(params[:id])
  end

end
