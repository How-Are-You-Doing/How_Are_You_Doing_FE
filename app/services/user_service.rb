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
    response = DatabaseService.conn(user).get("api/v1/friends?request_status=#{request_status}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.friends(user)
    response = DatabaseService.conn(user).get('api/v1/friends')
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
    DatabaseService.conn(current_user).post("api/v1/friends?email=#{email}")
  end

  def self.sent_requests(google_id)
    requests = DatabaseService.sent_requests(google_id)
    return requests if requests.empty?
    requests[:data].map { |user| UserPoro.new(user)}
  end
end
