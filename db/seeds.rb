require "csv"

def log(msg, type: :full)
  case type
  when :full
    print "-----> #{msg}"
    if block_given?
      ms = Benchmark.ms { yield }
      milliseconds = "#{ms.to_i}ms"
      print "\r-----> #{milliseconds.ljust(8, ' ')} #{msg}"
    end
    print "\n"
  when :sub
    puts "                #{msg}"
  else
    raise "Unknown type #{type}"
  end
end

log "Seeding Database"

ms = Benchmark.ms do
  require_relative "./seeds/seeds_helper.rb"
  require_relative "./seeds/default/seeds.rb"
  require_relative "./seeds/demo/seeds.rb" if ENV["DEMO"] || Rails.env.development?
end

log "Database seeding completed in #{ms / 1000}s"
