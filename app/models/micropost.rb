class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  default_scope -> {order(created_at: :DESC)}
  # find all posts by a user
  def self.feed(user_id)
    self.where("user_id = ?", user_id)
  end
end
