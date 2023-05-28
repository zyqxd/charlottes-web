# frozen_string_literal: true

# == Schema Information
#
# Table name: github_pull_requests
#
#  id                    :bigint           not null, primary key
#  closed_at             :datetime
#  comments_count        :integer          default(0), not null
#  commits_count         :integer          default(0), not null
#  lines_added           :integer          default(0), not null
#  lines_removed         :integer          default(0), not null
#  merged_at             :datetime
#  number                :integer          not null
#  repository            :string           not null
#  repository_url        :string           not null
#  review_comments_count :integer          default(0), not null
#  reviews_count         :integer          default(0), not null
#  state                 :string           not null
#  title                 :string           not null
#  url                   :string           not null
#  user                  :string           not null
#  user_url              :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  repository_id         :bigint           not null
#  user_id               :bigint           not null
#
class GithubPullRequest < ApplicationRecord
  has_many :github_reviews, dependent: :destroy, inverse_of: :github_pull_request

  enum state: {
    open: "open",
    closed: "closed",
  }
  # closed prs 16346

  scope :group_by_week, ->(field = "created_at") {
    group("date_trunc('week', #{field})")
  }

  class << self
    def update_or_create_with(data)
      record = GithubPullRequest.find_or_initialize_by(number: data.number)

      record.update!(
        title: data.title,
        url: data.html_url,
        state: data.state,
        lines_added: data.additions,
        lines_removed: data.deletions,
        comments_count: data.comments,
        commits_count: data.commits,
        review_comments_count: data.review_comments,
        user: data.user.login,
        user_id: data.user.id,
        user_url: data.user.html_url,
        repository: data.base.repo.full_name,
        repository_id: data.base.repo.id,
        repository_url: data.base.repo.html_url,
        created_at: data.created_at,
        updated_at: data.updated_at,
        merged_at: data.merged_at,
        closed_at: data.closed_at,
      )

      record
    end
  end
end
