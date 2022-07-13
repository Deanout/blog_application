class Category < ApplicationRecord
  has_many :posts, dependent: :destroy

  def self.scheduled_category
    Category.create(name: "Scheduled at #{Time.now}",
                    display_in_nav: true)
  end
end
