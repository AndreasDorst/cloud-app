class StopVmService
  def self.call(payload)
    puts 'Starting really slow task!'
    puts "Payload: #{payload}"
    
    10.times do
      putc '.'
      sleep 1
    end
    puts '.'
    puts 'Slow task finished'
  end
end