# frozen_string_literal: true

namespace :sync_and_report_producthunt do
  desc 'Sync and report producthunt data'
  task run: :environment do
    SyncAndReportProducthunt.perform_now
  end
end
