# frozen_string_literal: true

# == Schema Information
#
# Table name: github_comments
#
#  id               :bigint           not null, primary key
#  body             :string           not null
#  url              :string           not null
#  user             :string           not null
#  user_url         :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  github_review_id :bigint           not null
#  node_id          :string           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_github_comments_on_github_review_id  (github_review_id)
#  index_github_comments_on_node_id           (node_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_review_id => github_reviews.id)
#
class GithubComment < ApplicationRecord
  belongs_to :github_review, counter_cache: :comments_count, inverse_of: :github_comments

  class << self
    def update_or_create_with(review, comment)
      record = find_or_initialize_by(node_id: comment.node_id)

      record.update!(
        github_review_id: review.id,
        user: comment.user.login,
        user_url: comment.user.html_url,
        user_id: comment.user.id,
        body: comment.body,
        url: comment.html_url,
        created_at: comment.created_at,
        updated_at: comment.updated_at,
      )
    end
  end
end
