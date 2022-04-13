class AfterSignupController < ApplicationController
  include Wicked::Wizard
  # steps :profile, :avatar, :finish
  # Asterisk means variable number of arguments
  steps(*User.form_steps)

  def show
    @user = current_user

    case step
    when 'sign_up'
      skip_step if @user.persisted?
    when 'set_address'
      @address = get_address
    when 'find_users'
      @users = User.all
    end

    render_wizard
  end

  def update
    @user = current_user
    case step
    when 'set_name'
      if @user.update(onboarding_params(step))
        render_wizard @user
      else
        render_wizard @user, status: :unprocessable_entity
      end
    when 'set_address'
      if @user.create_address(onboarding_params(step).except(:form_step))
        render_wizard @user
      else
        @address.destroy
        render_wizard @user, status: :unprocessable_entity
      end
    end
  end

  private

  def get_address
    if @user.address.nil?
      Address.new
    else
      @user.address
    end
  end

  def finish_wizard_path
    root_path
  end

  def onboarding_params(step = 'sign_up')
    permitted_attributes = case step
                           when 'set_name'
                             required_parameters = :user
                             %i[first_name last_name]
                           when 'set_address'
                             required_parameters = :address
                             %i[street city state zip country]
                           end
    params.require(required_parameters).permit(:id, permitted_attributes).merge(form_step: step)
  end
end
