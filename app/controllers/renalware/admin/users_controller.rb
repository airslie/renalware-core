module Renalware
  class Admin::UsersController < BaseController

    def index
      @search = User.search(params[:q])
      @users = @search.result(distinct: true)

      authorize @users
    end

    def edit
      load_user
    end

    def update
      load_user

      if update_user.call(update_params)
        redirect_to admin_users_path,
          notice: t(".success", model_name: "user")
      else
        flash[:error] = t(".failed", model_name: "user")
        render :edit
      end
    end

    private

    def load_user
      @user = User.find(params[:id])
      authorize @user
    end

    def update_params
      roles = fetch_roles(user_params[:role_ids])
      user_params.merge(roles: roles)
    end

    def user_params
      params.require(:user).permit(:approved, :unexpire, :telephone, role_ids: [])
    end

    def fetch_roles(role_ids)
      Role.fetch(role_ids)
    end

    def update_user
      @service ||= UpdateUser.new(@user)
    end
  end
end
