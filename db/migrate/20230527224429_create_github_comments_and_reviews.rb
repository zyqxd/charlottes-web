# frozen_string_literal: true

class CreateGithubCommentsAndReviews < ActiveRecord::Migration[7.0]
  def change
    add_column(:github_pull_requests, :reviews_count, :integer, default: 0, null: false)

    create_table(:github_reviews) do |t|
      t.references(:github_pull_request, null: false, foreign_key: true)
      t.string(:user, null: false)
      t.bigint(:user_id, null: false)
      t.string(:user_url, null: false)
      t.integer(:comments_count, default: 0, null: false)
      t.datetime(:submitted_at, null: false)

      t.timestamps
    end

    create_table(:github_comments) do |t|
      t.references(:github_reviews, null: false, foreign_key: true)
      t.string(:node_id, null: false, index: { unique: true })
      t.string(:url, null: false)
      t.string(:user, null: false)
      t.bigint(:user_id, null: false)
      t.string(:user_url, null: false)
      t.string(:body, null: false)
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
    end
  end
end
