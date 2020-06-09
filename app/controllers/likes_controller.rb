class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @ticket = Ticket.find(params[:ticket_id])
    unless @ticket.like?(current_user)
      @ticket.like(current_user)
      @ticket.create_notification_like!(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end

  def destroy
    @ticket = Like.find(params[:id]).ticket
    if @ticket.like?(current_user)
      @ticket.unlike(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.js
      end
    end
  end
end
