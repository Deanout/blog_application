class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :current_user
  before_action :set_query

  def set_query
    @query = Post.ransack(params[:q])
  end

  private

  def set_notifications
    notifications = Notification.where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end
end
