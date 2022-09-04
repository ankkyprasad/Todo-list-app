module Api
  module V1 
    class TaskResource < JSONAPI::Resource
      attributes :name, :completed
      has_one :user
    end
  end
end
