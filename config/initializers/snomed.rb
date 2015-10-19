require_dependency 'snomed'

# TODO: Feed in ENV vars for API here.
if ENV['SNOMED_API']
  snomed_api_config = {}
  %w(SNOMED_ENDPOINT SNOMED_DATABASE SNOMED_VERSION).each do |env_var|
    raise "#{env_var} is a required environment variable for Snomed::ApiAdapter" unless ENV.key?(env_var)
    config_key = env_var.split('_').last.downcase.to_sym # SNOMED_FOO becomes :foo
    snomed_api_config[config_key] = ENV[env_var]
  end
  Snomed.configure(snomed_api_config.merge(adapter: Snomed::ApiAdapter))
else
  Snomed.configure(adapter: Snomed::YamlAdapter)
end
