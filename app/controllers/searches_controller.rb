class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    date = params[:date].to_datetime - 9.hour if params[:date].present?
    @users = User.search(params[:word], date).page(params[:page]).with_attached_image
    @done_tickets = Ticket.search(params[:word], date).done.release.
      page(params[:page]).with_attached_images.includes(:user, [:like_users])
    @upcomming_tickets = Ticket.search(params[:word], date).upcomming.release.
      page(params[:page]).with_attached_images.includes(:user, [:like_users])
  end
end
