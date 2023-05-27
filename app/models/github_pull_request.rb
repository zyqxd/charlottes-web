# == Schema Information
#
# Table name: github_pull_requests
#
#  id                    :bigint           not null, primary key
#  author                :string           not null
#  author_url            :string           not null
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
#  state                 :string           not null
#  title                 :string           not null
#  url                   :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :string           not null
#  repository_id         :string           not null
#
class GithubPullRequest < ApplicationRecord
  enum state: {
    open: 'open',
    closed: 'closed',
    merged: 'merged',
  }
end
