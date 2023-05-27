
class SyncAndReportProducthunt < ApplicationJob
  queue_as :cron

  def perform(*args)
    puts "SyncAndReportProducthunt"
  end
end
