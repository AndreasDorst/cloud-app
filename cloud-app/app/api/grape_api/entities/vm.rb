class GrapeApi
  module Entities
    class Vm < Grape::Entity
      expose :id
      expose :name
      expose :configuration
      expose :cost, if: lambda { |object, options| options[:detail] == true }

      def configuration
        "#{object.cpu} CPU/#{object.ram} Gb"
      end
    end
  end
end