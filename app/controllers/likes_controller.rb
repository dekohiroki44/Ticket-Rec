class LikesController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    unless @event.like?(current_user)
      @event.like(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end

  def destroy
    @event = Like.find(params[:id]).event
    if @event.like?(current_user)
      @event.unlike(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end
end
