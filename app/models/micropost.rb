class Micropost < ApplicationRecord
  default_scope -> {order(created_at: :DESC)}
  mount_uploader :picture, PictureUploader
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  # find all posts by a user
  def self.feed(user)
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id=#{user.id}"
    self.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: user.id)
  end

  private
  def picture_size
    if picture.size > 2.megabyte
      errors.add(:picture, "The picture shoule be less than 2MB")
    end
  end

end
