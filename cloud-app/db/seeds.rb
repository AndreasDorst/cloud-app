ActiveRecord::Base.transaction do
  puts "Starting seed data generation..."

  # Create Tags
  tags = %w[fastest slowest db app ballancer rabbitmq sidekiq cache_db].map do |tag_name|
    Tag.create!(name: tag_name)
  end
  puts "Created #{tags.size} tags"
    
  # Create Users
  users = 10.times.map do |i|
    User.create!(
      first_name: "First_#{i}",
      last_name: "Last_#{i}",
      balance: rand(1000..10000)
    )
  end
  puts "Created #{users.size} users"

  # Create Projects
  projects = 10.times.map do |i|
    Project.create!(
      name: "Project_#{i}",
      state: 1
    )
  end
  puts "Created #{projects.size} projects"
    
  # Crete VMs
  vms = 10.times.map do |i|
    Vm.create!(
      name: "vm-#{i}",
      cpu: rand(1..16),
      ram: (1..64).step(4).to_a.sample,
      cost: rand(100..10000)
    )
  end
  puts "Created #{vms.size} VMs"

  
  tags = Tag.all
  users = User.all
  vms = Vm.all
  
  # Create HDDs
  HDD_TYPES = ['sas', 'ssd', 'sata'].freeze
  hdds = 20.times.map do |i|
    Hdd.create!(
      hdd_type: HDD_TYPES.sample,
      size: (300..1850).step(50).to_a.sample,
      vm: vms.sample
    )
  end
  puts "Created #{hdds.size} HDDs"

  # Create Orders
  orders = 100.times.map do |i|
    vm = vms.sample
    Order.create!(
      name: "order-#{i}-#{vm.name}",
      cost: vm.cost,
      status: 1,
      user: users.sample,
      tags: tags.sample(rand(8))
    )
  end
  puts "Created #{orders.size} orders"
  
  # Create Groups
  groups = 10.times.map do |i|
    Group.create!(
      name: "Group #{i}"
    )
  end
  puts "Created #{groups.size} groups"

  
  puts "Seed completed!"

rescue ActiveRecord::RecordInvalid => e
  puts "Seed error: #{e.message}"
  raise ActiveRecord::Rollback
end