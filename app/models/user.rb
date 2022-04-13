class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  has_one :address, dependent: :destroy, inverse_of: :user, autosave: true

  enum role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?

  # Class level accessor http://apidock.com/rails/Class/cattr_accessor
  cattr_accessor :form_steps do
    %w[sign_up set_name set_address find_users]
  end
  # Instance level accessor http://apidock.com/ruby/Module/attr_accessor
  attr_accessor :form_step

  accepts_nested_attributes_for :address, allow_destroy: true

  def form_step
    @form_step ||= 'sign_up'
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # validates %i[first_name last_name], presence: true, if: required_for_step(:set_name)
  with_options if: -> { required_for_step?('set_name') } do |step|
    step.validates :first_name, presence: true
    step.validates :last_name, presence: true
  end
  validates_associated :address, if: -> { required_for_step?('set_address') }

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?

    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if form_steps.index(step.to_s) <= form_steps.index(form_step.to_s)
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
