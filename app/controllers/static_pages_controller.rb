class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @done_events = current_user.events.done.page(params[:page]).with_attached_images.includes([:like_users])
      @upcomming_events = current_user.events.upcomming.page(params[:page]).with_attached_images.includes([:like_users])
      @unsolved_events = current_user.events.unsolved.page(params[:page]).with_attached_images.includes([:like_users])
      @next_event = @upcomming_events.first
    end
  end

  def about
  end
end
