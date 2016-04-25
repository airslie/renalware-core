module World
  module Clinics
  end
end

Dir[Rails.root.join("features/support/worlds/clinics/*.rb")].each { |f| require f }
