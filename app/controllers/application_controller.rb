class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :set_notifications, if: :current_user
  before_action :set_categories
  before_action :set_query

  private

  def set_query
    @query = Post.ransack(params[:q])
  end

  def set_categories
    @nav_categories = Category.where(display_in_nav: true)
  end

  def set_notifications
    notifications = Notification.includes(:recipient).where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end
end
