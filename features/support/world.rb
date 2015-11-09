Dir[Rails.root.join("features/support/worlds/*.rb")].each { |f| require f }

def add_class_to_world(klass_name)
  exclusions = ENV["TEST_DEPTH"] == "web" ? [:Domain] : [:Web]

  klass = klass_name.constantize

  # Add klass to World
  World(klass)

  # Only inject the world type we want
  constants = klass.constants - exclusions
  constants.each do |constant|
    add_class_to_world("#{klass.name}::#{constant}")
  end
end

add_class_to_world("World")

