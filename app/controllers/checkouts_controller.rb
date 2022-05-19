class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer

    @checkout_session = current_user
                        .payment_processor
                        .checkout(
                          mode: params[:payment_mode],
                          line_items: params[:line_items],
                          success_url: checkout_success_url
                        )
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @line_items = Stripe::Checkout::Session.list_line_items(params[:session_id])
  end

  # Get list of payments
  # 3.0.3 :039 > Stripe::PaymentIntent.list({customer: User.first.pay_customers.first.processor_id}).each do |int|
  #   3.0.3 :040 >   puts int.amount
  #   3.0.3 :041 > end
end
