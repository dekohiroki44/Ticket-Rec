class StaticPagesController < ApplicationController
  def home

    @events = current_user.events.page(params[:page]) if user_signed_in?
  end

  def about
  end
end
