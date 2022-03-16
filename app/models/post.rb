class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  has_rich_text :body
  belongs_to :user
  has_many :comments, dependent: :destroy
end
