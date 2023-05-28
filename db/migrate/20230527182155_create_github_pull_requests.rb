# frozen_string_literal: true

class CreateGithubPullRequests < ActiveRecord::Migration[7.0]
  def change
    create_table(:github_pull_requests) do |t|
      t.integer(:number, null: false)
      t.string(:title, null: false)
      t.string(:url, null: false)

      t.string(:user, null: false)
      t.bigint(:user_id, null: false)
      t.string(:user_url, null: false)

      t.string(:repository, null: false)
      t.bigint(:repository_id, null: false)
      t.string(:repository_url, null: false)

      t.string(:state, null: false)
      t.integer(:lines_added, null: false, default: 0)
      t.integer(:lines_removed, null: false, default: 0)
      t.integer(:commits_count, null: false, default: 0)
      t.integer(:comments_count, null: false, default: 0)
      t.integer(:review_comments_count, null: false, default: 0)

      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.datetime(:merged_at)
      t.datetime(:closed_at)
    end
  end
end
