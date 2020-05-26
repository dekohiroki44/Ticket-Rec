class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @events = @user.events.page(params[:page])
  end
end
