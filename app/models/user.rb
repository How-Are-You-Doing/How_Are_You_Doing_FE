class User < ApplicationRecord
  validates_presence_of :name, :email, :token, :google_id
  validates :email, uniqueness: true

  def self.find_or_create_by_auth(auth_data)
    user = self.find_or_create_by_provider_and_uid(auth_data["provider"], auth_data["uid"])
    if user.name != auth_data["user_info"]["name"]
      user.name = auth_data["user_info"]["name"]
      user.save
    end
    return user
  end
end
