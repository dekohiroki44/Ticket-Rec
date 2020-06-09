class SearchesController < ApplicationController
  def index
    @users = User.search(params[:search], "name").page(params[:page]).with_attached_image
    @done_tickets = Ticket.search(params[:search], "name").done.
      page(params[:page]).with_attached_images.includes(:user, [:like_users])
    @upcomming_tickets = Ticket.search(params[:search], "name").upcomming.
      page(params[:page]).with_attached_images.includes(:user, [:like_users])
  end
end
