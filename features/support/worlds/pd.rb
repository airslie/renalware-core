module World
  module PD
  end
end

Dir[Rails.root.join("features/support/worlds/pd/*.rb")].each { |f| require f }
