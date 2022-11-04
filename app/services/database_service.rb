class DatabaseService
  # DATABASE_URL = ENV.fetch('DATABASE_URL', 'http://localhost:5000') a constant that fetches the given DATABASE_URL or defaults to localhost:5000, would need to adjust settings in Heroku

  def self.conn(user = nil)
    Faraday.new(url: 'http://localhost:5000') do |req|
      req.headers['USER'] = user.google_id if user
    end
  end
end
