class User < ApplicationRecord
  validates :name, presence: true, length: {minimum: 3}
  validates :username, presence: true, uniqueness: true, length: {minimum: 3, maximum: 500}, format: { with: /\A[a-zA-Z0-9]+\z/, message: "only alpha numeric allowed" }
  # validates :password, presence: true, length: {minimum: 8}
  has_secure_password
  
  has_many :tasks, dependent: :destroy
end
