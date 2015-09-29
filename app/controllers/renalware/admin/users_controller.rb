module Renalware
  class Admin::UsersController < BaseController

    before_filter :load_user, only: [:edit, :update]

    def index
      @users = User.all
      authorize @users
    end

    def unapproved
      @users = User.unapproved
      authorize @users, :index?
      render :index
    end

    def inactive
      @users = User.inactive
      authorize @users, :index?
      render :index
    end

    def update
      if user_service.update_and_notify!(service_params)
        redirect_to admin_users_path, notice: "#{@user.username} updated"
      else
        flash[:alert] = "#{@user.username} could not be updated"
        render :edit
      end
    end

    private

    def load_user
      @user = User.find(params[:id])
      authorize @user
    end

    def service_params
      roles = fetch_roles(user_params[:role_ids])
      user_params.merge(roles: roles)
    end

    def user_params
      params.require(:user).permit(:approved, :unexpire, role_ids: [])
    end

    def fetch_roles(role_ids)
      return if role_ids.nil?
      return [] if role_ids.empty?
      Role.where(id: role_ids.map(&:to_i))
    end

    def user_service
      @service ||= Admin::UserService.new(@user)
    end
  end
end