class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    event = current_user.events.build(event_params)
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
    if event.update_attributes(event_params)
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

  def event_params
    params.
    require(:event).
    permit(:name, :content, :date, :place, :time, :price, :performer, :public, images: [])
  end
end
