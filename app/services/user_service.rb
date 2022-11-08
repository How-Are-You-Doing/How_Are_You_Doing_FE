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
    response = DatabaseService.conn(user).get("api/v2/friends?request_status=#{request_status}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.friends(user)
    response = DatabaseService.conn(user).get('api/v2/friends')
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.friend_posts(google_id)
    response = DatabaseService.conn.get("/api/v1/friends/#{google_id}/posts")
    JSON.parse(response.body, symbolize_names: true)
  end


  def self.create(user)
    response = DatabaseService.conn.post 'api/v1/users' do |req|
      req.headers[:google_id] = user.google_id
      req.headers[:name] = user.name
      req.headers[:email] = user.email
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.send_friend_request(current_user, email)
    require "pry"; binding.pry
    DatabaseService.conn(current_user).post("api/v2/friends?email=#{email}&user=#{current_user.google_id}")
  end

  def self.sent_requests(google_id)
    requests = DatabaseService.sent_requests(google_id)
    return requests if requests.empty?
    requests[:data].map { |user| UserPoro.new(user)}
  end
end
