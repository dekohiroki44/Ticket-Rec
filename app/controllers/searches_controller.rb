class SearchesController < ApplicationController
  def index
    @users = User.search(params[:word], params[:date]).page(params[:page]).with_attached_image
    @done_tickets = Ticket.search(params[:word], params[:date]).done.
      page(params[:page]).with_attached_images.includes(:user, [:like_users])
    @upcomming_tickets = Ticket.search(params[:word], params[:date]).upcomming.
      page(params[:page]).with_attached_images.includes(:user, [:like_users])
  end
end
