require 'snomed'

if ENV['SNOMED_API']
  Snomed.configure(adapter: Snomed::ApiAdapter)
else
  Snomed.configure(adapter: Snomed::YamlAdapter)
end
