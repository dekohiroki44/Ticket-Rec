class TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  require 'date'
  require 'httpclient'

  def index
    @ticket = current_user.feed
    @done_tickets = current_user.feed.done.page(params[:page]).
      with_attached_images.includes(:user, [:like_users])
    @upcomming_tickets = current_user.feed.upcomming.page(params[:page]).
      with_attached_images.includes(:user, [:like_users])
    @unsolved_tickets = []
  end

  def show
    @ticket = Ticket.find(params[:id])
    @comments = @ticket.comments.page(params[:page])
    @comment = Comment.new
    if (@ticket.date - DateTime.current).abs < 5.day &&
      @ticket.prefecture.present? &&
        (@ticket.weather.blank? || @ticket.temperature.blank?)
      @ticket.update(weather: @ticket.get_weather[0], temperature: @ticket.get_weather[1])
    end
  end

  def new
    @ticket = Ticket.new
  end

  def create
    ticket = current_user.tickets.build(ticket_params_create)
    if ticket.save
      flash[:success] = "チケットを作成しました"
      redirect_to ticket
    else
      respond_to do |format|
        format.js { render :new }
      end
    end
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    ticket = Ticket.find(params[:id])
    if params[:ticket][:image_ids]
      params[:ticket][:image_ids].each do |image_id|
        image = ticket.images.find(image_id)
        image.purge
      end
    end
    if ticket.update_attributes(ticket_params_update)
      flash[:success] = "チケットを編集しました"
      redirect_to ticket
    else
      format.js { render :edit }
    end
  end

  def destroy
    ticket = Ticket.find(params[:id])
    ticket.destroy
    flash[:success] = "チケットを削除しました"
    redirect_to user_url(ticket.user)
  end

  def unsolved
    ticket = Ticket.find(params[:id])
    ticket.update_attributes(done: true)
    flash[:success] = "参加済みのチケットに移動しました"
    redirect_to ticket.user
  end

  private

  def ticket_params_create
    if params[:ticket][:date].present?
      params[:ticket][:date].to_date < DateTime.current ? done = true : done = false
      params.
        require(:ticket).
        permit(:name,
               :content,
               :date,
               :place,
               :prefecture,
               :price,
               :artist,
               :public,
               images: []).
        merge(done: done)
    end
  end

  def ticket_params_update
    params.
      require(:ticket).
      permit(:name,
             :content,
             :date,
             :place,
             :prefecture,
             :price,
             :artist,
             :weather,
             :temperature,
             :public,
             :done,
             images: [])
  end
end
