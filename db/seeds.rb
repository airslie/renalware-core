require "csv"

def log(msg, type: :full)
  case type
  when :full
    puts "-----> #{msg}"
  when :sub
    puts "       #{msg}"
  else
    raise "Unknown type #{type}"
  end
end

log "Seeding Database"

require_relative "./seeds/default/seeds.rb"
require_relative "./seeds/demo/seeds.rb" if ENV["DEMO"] || Rails.env.development?

log "Database seeding complete!"
