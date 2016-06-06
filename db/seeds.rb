require "csv"

def log(msg)
  puts msg
end

log "--------------------Seeding Database--------------"

unless Rails.env.test?
  require_relative "./seeds/default/seeds.rb"
  require_relative "./seeds/demo/seeds.rb" if ENV["DEMO"] || Rails.env.development?
end

log "--------------------Database seeding complete!----------"
