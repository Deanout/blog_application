class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :current_user
  before_action :set_categories
  before_action :set_query

  def set_query
    @query = Post.ransack(params[:q])
  end

  def is_admin!
    redirect_to root_path, alert: 'You are not authorized to do that.' unless current_user&.admin?
  end

  private

  def set_categories
    @nav_categories = Category.where(display_in_nav: true).order(:name)
  end

  def set_notifications
    notifications = Notification.includes(:recipient).where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end
end
