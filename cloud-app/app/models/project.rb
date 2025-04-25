class Project < ApplicationRecord
  has_many :project_vms #, dependent: :destroy
  has_many :vms, through: :project_vms

  validates :name, presence: true, uniqueness: true
end
