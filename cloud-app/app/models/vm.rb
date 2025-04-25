class Vm < ApplicationRecord
  has_many :project_vms
  has_many :projects, through: :project_vms

  validates :name, presence: true
end
