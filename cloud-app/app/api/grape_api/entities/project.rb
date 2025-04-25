class GrapeApi
  module Entities
    class Project < Grape::Entity
      expose :name
      expose :state
      expose :created_at
      expose :vms, using: Entities::Vm
    end
  end
end