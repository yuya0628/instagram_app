# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  read         :boolean          default(FALSE), not null
#  subject_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_activities_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_activities_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord

  include Rails.application.routes.url_helpers

  belongs_to :subject, polymorphic: true
  belongs_to :user

  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }

  enum read: { read: true, unread: false }

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  def redirect_path
    case self.action_type.to_sym
    when :liked_to_own_post
      post_path(self.subject.post)
    when :commented_to_own_post
      post_path(self.subject.post, anchor: "comment-#{self.subject.id}")
    when :followed_me
      user_path(self.subject.follower)
    end
  end


end
