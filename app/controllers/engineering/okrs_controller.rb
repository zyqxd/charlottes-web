# frozen_string_literal: true

module Engineering
  class OkrsController < ApplicationController
    PR_SUMMARY_COLUMNS = [
      '"github_pull_requests"."user"',
      "date_trunc('week', merged_at) as week",
      "sum(lines_added) as lines_added",
      "sum(lines_removed) as lines_removed",
      "count(*) as prs_count",
    ]
    MAX_LINES_PER_PR = 500

    REVIEW_SUMMARY_COLUMNS = [
      '"github_reviews"."user"',
      "date_trunc('week', submitted_at) as week",
      "count(*) as reviews_count",
      "sum(comments_count) as comments_count",
    ]
    EFFECTIVE_REVIEW_LIMIT = 20
    MIN_COMMENT_MULTIPLIER = 0.5

    def index
      @merged_prs = ::GithubPullRequest.closed.where.not(merged_at: nil)
      @pr_weeks = @merged_prs.group_by_week("merged_at").count.map(&:first).sort

      @prs_summary =
        @merged_prs
          .group("user")
          .group_by_week("merged_at")
          .select(PR_SUMMARY_COLUMNS.join(", "))
          .group_by(&:user)
          .transform_values do |raw_pr_data|
          prs_per_week = raw_pr_data.group_by(&:week)
          prs_per_week.transform_values do |raw_pr_weeks|
            total_lines = raw_pr_weeks[0].lines_added + raw_pr_weeks[0].lines_removed
            total_prs = raw_pr_weeks[0].prs_count

            # SQRT( # PRs * MIN( lines, MLP * # PRs ) )
            Math.sqrt(total_prs * [total_lines, MAX_LINES_PER_PR * total_prs].min).round
          end
        end

      @review_weeks = ::GithubReview.group_by_week.count.map(&:first).sort
      @reviews_summary =
        ::GithubReview
          .group("user", "submitted_at")
          .select(REVIEW_SUMMARY_COLUMNS.join(", "))
          .group_by(&:user)
          .transform_values do |raw_review_data|
            reviews_per_week = raw_review_data.group_by(&:week)
            reviews_per_week.transform_values do |raw_review_weeks|
              total_comments = raw_review_weeks[0].comments_count
              total_reviews = raw_review_weeks[0].reviews_count

              # MIN( # reviews, UL ) * ( avg depth + MDM )
              [
                total_reviews,
                EFFECTIVE_REVIEW_LIMIT,
              ].min * (total_comments / total_reviews.to_f + MIN_COMMENT_MULTIPLIER)
            end
          end
    end
  end
end
