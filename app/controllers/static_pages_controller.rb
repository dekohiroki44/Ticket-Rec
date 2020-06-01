class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @done_events = current_user.events.done.page(params[:page]).with_attached_images
      @upcomming_events = current_user.events.upcomming.page(params[:page]).with_attached_images
      @unsolved_events = current_user.events.unsolved.page(params[:page]).with_attached_images
    end
  end

  def about
  end
end
