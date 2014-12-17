class UsersController < ApplicationController

  load_and_authorize_resource

  def index
    @users = User.all.sort_by(&:wins).reverse
  end

  def show
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to(@user)
    else
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(
      :name,
      :profile
      )
  end

end