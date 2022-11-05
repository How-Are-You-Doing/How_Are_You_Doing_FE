class UserService
  def self.find_user(google_id)
    response = DatabaseService.conn.get("/api/v1/users?search=#{google_id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search(email)
    response = DatabaseService.conn.get("/api/v1/users?email=#{email}")
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
end
