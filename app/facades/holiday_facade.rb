class HolidayFacade 
  
  def self.pull_holidays
    info = {
      holidays: get_holidays
    }
    
    Holidays.new(info)
  end

  def self.get_holidays
    holidays = HolidaysService.fetch_api("/MX")
  end

end