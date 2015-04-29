require 'snomed/adapter'

module Snomed

  module_function

  def configure(config={})
    @configuration ||= config
  end

  def adapter
    configure unless @configuration.present?
    @adapter ||= AdapterFactory.new(@configuration).adapter
  end

  def search(params={})
    adapter.search(params)
  end

end
