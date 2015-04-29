require 'snomed/adapter'

module Snomed

  def self.configure(config={})
    @configuration ||= config
  end

  def self.adapter_factory
    @factory ||= AdapterFactory.new(@configuration)
  end

  def self.search(term, params={})
    adapter_factory.adapter.search(term, params)
  end

end


