module Renalware
  class Admin::UsersController < BaseController

    before_filter :load_user, only: [:edit, :update]

    def index
      @search = User.search(params[:q])
      @users = @search.result(distinct: true)

      authorize @users
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
      Role.fetch(role_ids)
    end

    def user_service
      @service ||= Admin::UserService.new(@user)
    end
  end
end
