class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @user = User.find(current_user.id)
      @done_events = current_user.events.done.page(params[:page])
      @upcomming_events = current_user.events.upcomming.page(params[:page])
      @unsolved_events = current_user.events.unsolved.page(params[:page])
    end
  end

  def about
  end
end
