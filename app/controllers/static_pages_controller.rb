class StaticPagesController < ApplicationController
  def home
    @feed_items = current_user.feed
  end

  def about
  end
end
