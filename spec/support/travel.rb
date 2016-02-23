RSpec.configure do |config|

  config.after(:each) do
    travel_back
  end

end