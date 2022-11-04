class UserService

  def self.find_user(google_id)
    response = DatabaseService.conn.get("/api/v1/users?search=#{google_id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search(email)
    response = DatabaseService.conn.get("/api/v1/users?email=#{email}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.friends_of(user)
    response = DatabaseService.conn(user).get("api/v1/friends")
    JSON.parse(response.body, symbolize_names: true)
  end
end
