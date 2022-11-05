class DatabaseService
  # DATABASE_URL = ENV.fetch('DATABASE_URL', 'http://localhost:5000') a constant that fetches the given DATABASE_URL or defaults to localhost:5000, would need to adjust settings in Heroku

  def self.conn(user = nil)
    Faraday.new(url: 'http://localhost:5000') do |req|
      req.headers['USER'] = user.google_id if user
    end
  end

  def self.pending_requests(google_id)
    response = conn.get("/api/v1/friends?request_status=pending") do |req|
      req.headers[:user] = google_id
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.emotions
    response = conn.get('/api/v1/emotions')
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.last_post(user)
    response = conn.get("/api/v1/posts/last") do |req|
      req.headers[:user] = user.google_id
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
