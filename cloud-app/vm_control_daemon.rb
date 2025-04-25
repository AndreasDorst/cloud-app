# Daemon for sending status to vm.status
require 'bunny'
require './app/services/stop_vm_service.rb'

connection = Bunny.new('amqp://guest:guest@rabbitmq')
connection.start

channel = connection.create_channel

# Listening vm.control queue
queue = channel.queue('vm.control', auto_delete: false)

# Send status to vm.status
status_exchange = channel.default_exchange

begin
  puts 'listening'
  queue.subscribe(block: true) do |_delivery_info, _metadata, payload|
    puts "Processing: #{payload}"
    StopVmService.call(payload)
    
    # Send message to vm.status
    status_exchange.publish('vm_stopped', routing_key: 'vm.status')
    puts 'Stautus sended to vm.status'
  end
rescue Interrupt => _
  puts 'exiting'
  connection.close
  exit(0)
end