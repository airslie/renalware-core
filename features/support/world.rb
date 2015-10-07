Dir[Rails.root.join("features/support/worlds/**/*.rb")].each { |f| require f }

world_type = ENV["TEST_DEPTH"] == "web" ? "Web" : "Domain"
World.constants.each do |constant|
  World("World::#{constant}::#{world_type}".constantize)
end
