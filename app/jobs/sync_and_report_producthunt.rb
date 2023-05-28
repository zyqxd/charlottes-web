# frozen_string_literal: true

class SyncAndReportProducthunt < ApplicationJob
  queue_as :cron

  REPO = "producthunt/producthunt"
  STOP_DATE = Date.new(2023, 1, 1)
  MIN_COMMENT_SIZE = 5

  # TODO(DZ): Github API can be moved into external
  # TODO(DZ): Throttle job with 5000 api calls per hour
  # TODO(DZ): Job should only run new prs unless specified
  # TODO(DZ): Figure out how to organize by updated at
  def perform(*args)
    page = repo.rels[:pulls].get(query: { direction: "desc", state: "all" })
    process_page(page)

    while page.rels[:next]
      page = page.rels[:next].get
      process_page(page)

      break if page.data.last.created_at.to_date < STOP_DATE
    end
  end

  def process_page(pulls)
    pulls.data.each do |pull_raw|
      number = pull_raw.number
      pull = repo.rels[:pulls].get(uri: { number: number })
      raise "Pull ##{number} is not found" if pull.blank?

      pr = GithubPullRequest.update_or_create_with(pull.data)
      process_comments(pr)

      Rails.logger.info("Processed pull ##{number}")
    rescue StandardError => e
      Rails.logger.error("Error processing pull ##{number}: #{e.message}")
    end
  end

  def process_comments(pr)
    reviews = Set.new
    client.pull_request_reviews(REPO, pr.number).filter do |review|
      review.user.id != pr.user_id
    end.uniq { |review| review.user.id }.each do |review|
      reviews << GithubReview.update_or_create_with(pr, review)
    end

    client.pull_request_comments(REPO, pr.number).filter do |comment|
      comment.body.size > MIN_COMMENT_SIZE && comment.user.id != pr.user_id
    end.each do |comment|
      review = reviews.find { |r| r.user_id == comment.user.id }
      GithubComment.update_or_create_with(review, comment)
    end
  end

  def client
    @client ||= Octokit::Client.new(access_token: Credentials.github_pat_token)
  end

  def repo
    @repo ||= client.repo(REPO)
  end
end
