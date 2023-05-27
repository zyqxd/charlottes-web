# frozen_string_literal: true

class SyncAndReportProducthunt < ApplicationJob
  queue_as :cron

  def perform(*args)
    puts "SyncAndReportProducthunt"
  end
end
