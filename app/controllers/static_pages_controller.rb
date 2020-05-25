class StaticPagesController < ApplicationController
  def home
    @events = current_user.events
  end

  def about
  end
end
