SimpleCov.start 'rails' do
  # any custom configs like groups and filters can be here at a central place
  add_filter '/spec/models/concerns'
  add_filter '/features'
  add_filter '/spec/support'
end
