class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @done_events = @user.events.done.page(params[:page])
    @upcomming_events = @user.events.upcomming.page(params[:page])
    @unsolved_events = @user.events.unsolved.page(params[:page])
    if current_user != @user
      @done_events = @done_events.release
      @upcomming_events = @upcomming_events.release
      @unsolved_events = @unsolved_events.release
    end
  end
end
