module ApplicationHelper
  def is_admin?
    authenticate_user!

    redirect_to root_path, notice: 'You are not authorized to view that page.' unless current_user.admin?
  end
end
