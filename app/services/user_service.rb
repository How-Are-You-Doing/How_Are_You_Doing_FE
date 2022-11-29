class UserService
  def self.find_user(google_id)
    response = DatabaseService.conn.get("/api/v2/users?search=#{google_id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search(email)
    response = DatabaseService.conn.get("/api/v2/users?email=#{email}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.user_relationships_filter(user, request_status)
    response = DatabaseService.conn.get("api/v2/friends") do |req|
      req.params[:user] = user.google_id
      req.params[:request_status] = request_status
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.friends(user)
    response = DatabaseService.conn.get('api/v2/friends') do |req|
      req.params[:user] = user.google_id
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.friend_posts(google_id)
    response = DatabaseService.conn.get("/api/v1/friends/#{google_id}/posts")
    JSON.parse(response.body, symbolize_names: true)
  end


  def self.create(user)
    response = DatabaseService.conn.post 'api/v2/users' do |req|
      req.params[:google_id] = user.google_id
      req.params[:name] = user.name
      req.params[:email] = user.email
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.send_friend_request(current_user, email)
    DatabaseService.conn.post("api/v2/friends")do |req|
      req.params[:user] = current_user.google_id
      req.params[:email] = email
    end
  end

  def self.sent_requests(google_id)
    requests = DatabaseService.sent_requests(google_id)
    return requests if requests.empty?
    requests[:data].map { |user| UserPoro.new(user)}
  end
end
