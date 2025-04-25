class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :networks
  has_and_belongs_to_many :tags
  # validates :name, length: { maximum: 10 }

  before_save :calculate_cost

  private

  def calculate_cost
    return unless options
  
    self.cost = 0

    if options['hdd']
      hdd_type = options['hdd']['type']
      hdd_size = options['hdd']['size'].to_i

      case hdd_type
      when 'sas'
        self.cost += hdd_size * 100
      when 'sata'
        self.cost += hdd_size * 200
      when 'ssd'
        self.cost += hdd_size * 300
      end
    end

    self.cost += options['ram'].to_i / 1024 * 150 if options['ram']
    self.cost += options['cpu'].to_i * 1000 if options['cpu']
  end
end
