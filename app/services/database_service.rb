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

  def self.last_post(google_id) #using v2 according to Aleisha's newest endpoint drop. I'm gonna pass this back to you and update the docs from here.
    response = conn.get("/api/v2/posts/last?user=#{google_id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.new_post(post)
    response = conn.post("/api/v2/posts") do |req|
      req.params[:user] = post.user_google_id
      req.params[:description] = post.description
      req.params[:post_status] = post.post_status
      req.params[:emotion] = post.emotion
    end
    # response.status == 201 edge case when it isn't...
    JSON.parse(response.body, symbolize_names: true)
  end
end
