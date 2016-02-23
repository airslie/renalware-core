module World
  module Problems
  end
end

Dir[Rails.root.join("features/support/worlds/problems/*.rb")].each { |f| require f }
