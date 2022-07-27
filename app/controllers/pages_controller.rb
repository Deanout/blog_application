class PagesController < ApplicationController
  def home
    Rails.logger.info('pages#home') do
      'Rendered the homepage'
    end
    return unless current_user
    return if current_user.payment_processor.nil?

    @portal_session = current_user.payment_processor.billing_portal
  end

  def about; end
end
