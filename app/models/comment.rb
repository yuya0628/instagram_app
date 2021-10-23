# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  validates :body,presence:true,length: { maximum: 1000 }

  has_one :activity, as: :subject, dependent: :destroy

  after_create_commit :create_activities

  private
  def create_activities
    Activity.create(subject: self, user: self.post.user, action_type: :commented_to_own_post)
  end

end
