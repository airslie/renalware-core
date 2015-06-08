class Admin::UsersController < ApplicationController

  before_filter :load_user, only: [:edit, :update]

  def index
    @users = (
      if params[:approved] == 'false'
        User.unapproved.order(:username)
      else
        User.order(:username)
      end
    )
  end

  def update
    if @user.authorise!(fetch_roles, approve?)
      redirect_to admin_users_path, notice: "#{@user.username} updated"
    else
      flash[:alert] = "#{@user.username} could not be updated"
      render :edit
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:approved, role_ids: [])
  end

  def fetch_roles
    return [] if user_params[:role_ids].nil?
    role_ids = user_params[:role_ids].map(&:to_i)
    Role.where(id: role_ids)
  end

  def approve?
    user_params[:approved] == 'true'
  end
end
