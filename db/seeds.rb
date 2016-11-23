require "csv"

def log(msg, type: :full)
  case type
  when :full
    print "-----> #{msg}"
    if block_given?
      ms = Benchmark.ms { yield }
      print "...#{ms.to_i}ms"
    end
    print "\n"
  when :sub
    puts "       #{msg}"
  else
    raise "Unknown type #{type}"
  end
end

log "Seeding Database"

ms = Benchmark.ms do
  require_relative "./seeds/default/seeds.rb"
  require_relative "./seeds/demo/seeds.rb" if ENV["DEMO"] || Rails.env.development?
end

log "Database seeding completed in #{ms / 1000}s"
