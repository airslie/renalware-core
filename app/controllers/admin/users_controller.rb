class Admin::UsersController < ApplicationController

  def index
    @users = params[:approved] == 'false' ? User.where(approved: false) : User.all
  end
end
