# Daemon for sending message to vm.control and listening vm.status
require 'bunny'

connection = Bunny.new('amqp://guest:guest@rabbitmq')
connection.start

channel = connection.create_channel

# Sending message to vm.control
control_queue = channel.queue('vm.control', auto_delete: false)
control_exchange = channel.default_exchange
control_exchange.publish('init_vm_stop', routing_key: 'vm.control')

# Listening vm.status queue
status_queue = channel.queue('vm_status')

puts 'listening'

begin
  status_queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts "Message recieved: #{body}"
    puts 'exititng'
    connection.close
    exit(0)
  end
rescue Interrupt => _
  puts 'exiting'
  connection.close
  exit(0)
end