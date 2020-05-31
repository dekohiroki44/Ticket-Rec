class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    notifications = current_user.passive_notifications
    notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    @notifications =  notifications.where.not(visitor_id: current_user.id).page(params[:page])
  end
end
