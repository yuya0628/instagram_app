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

  validates :name,presence: true
  validates :email, uniqueness: true, presence: true

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :posts, dependent: :destroy
  has_many :comments,dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }


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

  def follow(other_user)
    self.following << other_user
  end

  def unfollow(other_user)
    self.following.destroy(other_user)
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

  def feed
    Post.where(user_id: following_ids << id)
  end
end
