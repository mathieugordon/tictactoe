class UsersController < ApplicationController

  load_and_authorize_resource

  def index
    params[:q] ||= {}
    params[:q][:s] ||= 'wins desc'
    @q = User.search(params[:q])
    @users = @q.result(distinct: true)
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
      :profile_text,
      :user_image,
      :remote_user_image_url
      )
  end

end