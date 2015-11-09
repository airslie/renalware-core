module World
  module Transplants
  end
end

Dir[Rails.root.join("features/support/worlds/transplants/*.rb")].each { |f| require f }
