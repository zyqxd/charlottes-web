# frozen_string_literal: true

# == Schema Information
#
# Table name: github_reviews
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer          default(0), not null
#  submitted_at           :datetime         not null
#  user                   :string           not null
#  user_url               :string           not null
#  github_pull_request_id :bigint           not null
#  user_id                :bigint           not null
#
# Indexes
#
#  index_github_reviews_on_github_pull_request_id  (github_pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (github_pull_request_id => github_pull_requests.id)
#
class GithubReview < ApplicationRecord
  belongs_to :github_pull_request, counter_cache: :reviews_count, inverse_of: :github_reviews

  has_many :github_comments, inverse_of: :github_review, dependent: :destroy

  scope :group_by_week, -> { group("date_trunc('week', submitted_at)") }

  class << self
    def update_or_create_with(pr, review)
      record = find_or_initialize_by(
        user_id: review.user.id,
        github_pull_request_id: pr.id,
      )

      record.update!(
        user: review.user.login,
        user_url: review.user.html_url,
        submitted_at: review.submitted_at,
      )

      record
    end
  end
end
