# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  validates :user_id, uniqueness: {scope: :post_id}

  has_one :activity, as: :subject, dependent: :destroy

  after_create_commit :create_activities

  private
  def create_activities
    Activity.create(subject: self, user: self.post.user, action_type: :liked_to_own_post)
  end
end
