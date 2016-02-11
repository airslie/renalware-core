module World
  module Accesses
  end
end

Dir[Rails.root.join("features/support/worlds/accesses/*.rb")].each { |f| require f }
