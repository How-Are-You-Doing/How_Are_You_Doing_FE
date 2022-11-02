class User < ApplicationRecord
  validates_presence_of :name, :email, :token, :google_id
  validates :email, uniqueness: true
end
