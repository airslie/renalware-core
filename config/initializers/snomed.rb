require 'snomed'

# TODO: Feed in ENV vars for API here.
if ENV['SNOMED_API']
  Snomed.configure(adapter: Snomed::ApiAdapter)
else
  Snomed.configure(adapter: Snomed::YamlAdapter)
end
