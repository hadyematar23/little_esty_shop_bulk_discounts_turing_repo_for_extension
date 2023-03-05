class HolidaysService
  def self.fetch_api(arg)
    response = connection.get("/api/v3/NextPublicHolidays#{arg}")
    x = JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    url = "https://date.nager.at"
    Faraday.new(url: url, headers: {"Authorization" => "Bearer #{ENV['github_token']}"})
  end
end