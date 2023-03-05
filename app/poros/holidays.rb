class Holidays 
  attr_reader :next_three_holidays
  def initialize(info)
    @next_three_holidays = info[:holidays][0..2]
  end
end