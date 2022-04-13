class Address < ApplicationRecord
  belongs_to :user, inverse_of: :address
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :country, presence: true
end
