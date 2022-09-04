module Api 
  module V1 
    class UserResource < JSONAPI::Resource
      attributes :name, :username, :password_digest
      has_many :tasks
    end
  end
end
