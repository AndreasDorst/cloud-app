class Hdd < ApplicationRecord
  belongs_to :vm

  validates :hdd_type, presence: true
  
  validates :size,
    numericality: {
      greater_than: 0,
      only_integer: true
    }
end
