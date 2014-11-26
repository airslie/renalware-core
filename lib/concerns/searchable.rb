module Concerns::Searchable
  require 'elasticsearch/model'

  def self.included(klass)
    klass.class_eval do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
    end
  end
end