require 'csv'
require_relative 'models'
require_relative 'constants'

class DataLoader
  def self.load_vms(file)
    vms = []
    CSV.foreach(file, headers: false) do |row|
      vms << Models::VM.new(
        id: row[0].to_i,
        cpu: row[1].to_i,
        ram: row[2].to_i,
        type: row[3],
        disks: row[4].to_i
      )
    end
    vms
  end

  def self.load_volumes(file, vms)
    CSV.foreach(file, headers: false) do |row|
      vm = vms.find { |v| v.id == row[0].to_i }
      vm&.add_volume(Models::Volume.new(
        type: row[1],
        capacity: row[2].to_i
      ))
    end
  end

  def self.load_prices(file)
    prices = {}
    CSV.foreach(file) do |row|
      prices[row[0].to_sym] = Models::Price.new(
        type: row[0],
        price: row[1].to_i
      )
    end
    prices
  end
end 