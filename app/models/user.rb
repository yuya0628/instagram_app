# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  avatar           :string(255)
#  crypted_password :string(255)
#  email            :string(255)      not null
#  name             :string(255)      not null
#  salt             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :email, uniqueness: true, presence: true
  validates :password, presence: true
  validates :name,presence: true

  has_many :posts, dependent: :destroy
  has_many :comments,dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  def own?(object)
    id == object.user_id
  end

  def like(post)
    self.likes.find_or_create_by(post_id: post.id)
  end

  def unlike(post)
    self.like_posts.destroy(post)
  end

  def like?(post)
    self.like_posts.include?(post)
  end
end
