Dir[Rails.root.join("features/support/worlds/*.rb")].each { |f| require f }

$world_methods = []

def add_class_to_world(klass_name)
  exclusions = ENV["TEST_DEPTH"] == "web" ? [:Domain] : [:Web]

  klass = klass_name.constantize

  # Add klass to World
  klass_methods = klass.instance_methods
  join = $world_methods & klass_methods
  if join.present?
    puts "ERROR: these methods from #{klass} are defined in more than one world:"
    puts join
    exit 1
  else
    $world_methods += klass_methods
    World(klass)
  end

  # Only inject the world type we want
  constants = klass.constants - exclusions
  constants.each do |constant|
    add_class_to_world("#{klass.name}::#{constant}")
  end
end

add_class_to_world("World")
