# frozen_string_literal: true

# == Schema Information
#
# Table name: github_comments
#
#  id                :bigint           not null, primary key
#  body              :string           not null
#  url               :string           not null
#  user              :string           not null
#  user_url          :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_reviews_id :bigint           not null
#  node_id           :string           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_github_comments_on_github_reviews_id  (github_reviews_id)
#  index_github_comments_on_node_id            (node_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_reviews_id => github_reviews.id)
#
class GithubComment < ApplicationRecord
  belongs_to :github_review, counter_cache: :comments_count, inverse_of: :github_comments

  class << self
    def update_or_create_with(review, comment)
      record = find_or_initialize_by(node_id: comment.node_id)

      record.update!(
        github_review_id: review.id,
        user: data.user.login,
        user_url: data.user.html_url,
        body: data.body,
        url: data.html_url,
        created_at: data.created_at,
        updated_at: data.updated_at,
      )
    end
  end
end
