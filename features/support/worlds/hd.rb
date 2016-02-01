module World
  module Hd
  end
end

Dir[Rails.root.join("features/support/worlds/hd/*.rb")].each { |f| require f }
