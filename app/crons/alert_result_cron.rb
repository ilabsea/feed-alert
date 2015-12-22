class AlertResultCron < CronBase

  def perform(*args)
    ApplySearch.run
  end

end