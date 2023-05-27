# frozen_string_literal: true

class SyncAndReportProducthunt < ApplicationJob
  queue_as :cron

  REPO = 'producthunt/producthunt'

  # TODO(DZ): Github API can be moved into external
  # TODO(DZ): Throttle job with 5000 api calls per hour
  def perform(*args)
    page = repo.rels[:pulls].get(query: { direction: 'asc', state: 'all' })
    process_page(page)

    while page.rels[:next]
      page = page.rels[:next].get
      process_page(page)
    end
  end

  def process_page(pulls)
    pulls.data.each do |pull_raw|
      number = pull_raw.number
      pull = repo.rels[:pulls].get(uri: { number: number })
      raise "Pull ##{number} is not found" unless pull.present?

      GithubPullRequest.update_or_create_with(pull)
      Rails.logger.info "Processed pull ##{number}"
    rescue StandardError => e
      Rails.logger.error "Error processing pull ##{number}: #{e.message}"
    end
  end

  def client
    @client ||= Octokit::Client.new(access_token: Credentials.github_pat_token)
  end

  def repo
    @repo ||= client.repo REPO
  end
end
