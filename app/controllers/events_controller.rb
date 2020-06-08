class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  require 'date'
  require 'httpclient'

  def index
    @event = current_user.feed
    @done_events = current_user.feed.done.page(params[:page]).
      with_attached_images.includes(:user, [:like_users])
    @upcomming_events = current_user.feed.upcomming.page(params[:page]).
      with_attached_images.includes(:user, [:like_users])
    @unsolved_events = current_user.feed.unsolved.page(params[:page]).
      with_attached_images.includes(:user, [:like_users])
  end

  def show
    @event = Event.find(params[:id])
    @comments = @event.comments.page(params[:page])
    @comment = Comment.new
    @image_url = @event.spotify[0]
    @track_url = @event.spotify[1]
  end

  def new
    @event = Event.new
  end

  def create
    event = current_user.events.build(event_params_create)
    if event.save
      flash[:success] = "イベントを作成しました"
      redirect_to event
    else
      render new_event_path
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    event = Event.find(params[:id])
    if params[:event][:image_ids]
      params[:event][:image_ids].each do |image_id|
        image = event.images.find(image_id)
        image.purge
      end
    end
    if event.update_attributes(event_params_update)
      flash[:success] = "イベントを編集しました"
      redirect_to event
    else
      render edit_event_path
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    flash[:success] = "イベントを削除しました"
    redirect_to events_url
  end

  private

  def event_params_create
    params[:event][:date].to_date < Date.current ? done = true : done = false
    params.
      require(:event).
      permit(:name, :content, :date, :place, :prefecture, :price, :performer, :public, images: []).
      merge(done: done)
  end

  def event_params_update
    params.
      require(:event).
      permit(:name, :content, :date, :place, :prefecture, :price, :performer, :public, :done, images: [])
  end
end
