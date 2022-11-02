class User
  attr_reader :name, :google_id, :email, :id

  def initialize(data)
    @name = data[:attributes][:name]
    @google_id = data[:attributes][:google_id]
    @email = data[:attributes][:email]
    @id = data[:id]
  end
end
