class DatabaseService
  # DATABASE_URL = ENV.fetch('DATABASE_URL', 'http://localhost:5000') a constant that fetches the given DATABASE_URL or defaults to localhost:5000, would need to adjust settings in Heroku

  def self.conn(user = nil)
    Faraday.new(url: 'http://localhost:5000') do |req|
      req.headers['USER'] = user.google_id if user
    end
  end

  # def self.pending_requests(google_id)
  #   response = conn.get("/api/v1/friends?request_status=pending") do |req|
  #     req.headers[:user] = google_id
  #   end
  #   JSON.parse(response.body, symbolize_names: true)
  # end

  #these are incoming pending friend requests for the user to accept or reject
  def self.users_pending_requests(google_id)
    response = conn.get("/api/v2/users/followers?request_status=pending") do |req|
      req.params[:user] = google_id
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.emotions
    response = conn.get('/api/v1/emotions')
    JSON.parse(response.body, symbolize_names: true)
  end

  #these are outgoing requests that display on the friends index once a request has been sent
  def self.sent_requests(google_id)
    response = conn.get("/api/v1/friends?request_status=pending") do |req|
      req.headers[:user] = google_id
    end
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

  def self.update_post(post_update_params)
    response = conn.put("/api/v2/posts/#{post_update_params[:id]}") do |req|
      req.params = post_update_params
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.lookup_post(user, post_id)
    response = conn.get("/api/v2/users/posts") do |req|
      req.params[:user] = user.google_id
      req.params[:post] = post_id
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.user_post_history(google_id)
    response = conn.get("/api/v2/users/history") do |req|
      req.params[:user] = google_id
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_friend_request(friendship_id, request_status)
    # needs friendship table record ID and the decision on status (accept/reject)
    #request status is numeric pending 0, accepted 1, rejected 2
    response = conn.put("/api/v2/friends/#{friendship_id}") do |req|
      req.params[:request_status] = request_status
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
