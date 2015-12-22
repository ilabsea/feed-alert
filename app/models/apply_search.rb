class ApplySearch

  def self.run
    from = Time.zone.now - ENV['PROCESS_TIME_IN_MINUTES'].to_i.minutes
    to   = Time.zone.now
    date_range = DateRange.new(from, to)

    Alert.apply_search(date_range)    
  end

end