class Post < ApplicationRecord
  extend FriendlyId
  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :body, presence: true
  belongs_to :category
  has_rich_text :body
  belongs_to :category

  belongs_to :user
  has_many :comments, dependent: :destroy

  has_rich_text :body
  has_one :content, class_name: 'ActionText::RichText', as: :record, dependent: :destroy

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user

  friendly_id :title, use: %i[slugged history finders]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

  def views_by_day
    daily_events = Ahoy::Event.where("cast(properties ->> 'post_id' as bigint) = ?", id)
    daily_events.group_by_day(:time, range: 1.month.ago..Time.now).count
  end

  def self.total_views_by_day
    daily_events = Ahoy::Event.where(name: 'Viewed Post')
    daily_events.group_by_day(:time, range: 1.month.ago..Time.now).count
  end
end
