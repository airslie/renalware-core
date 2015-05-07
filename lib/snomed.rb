module Snomed

  module_function

  def configure(config={})
    @configuration ||= config
  end

  def adapter
    configure unless @configuration.present?
    configured_adapter = @configuration[:adapter]
    (configured_adapter || YamlAdapter).new(@configuration)
  end

  def search(params={})
    adapter.search(params)
  end

end
