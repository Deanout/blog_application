class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :current_user

  private

  def set_notifications
    @unread = Notification.where(recipient: current_user).newest_first.limit(9).unread
    @read = Notification.where(recipient: current_user).newest_first.limit(9).read
  end
end
