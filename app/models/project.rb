class Project < ApplicationRecord
  has_rich_text :body
  acts_as_list
end
