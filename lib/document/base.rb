module Document
  class Base
    include Virtus.model
    include ActiveModel::Model

    def self.dump(object)
      object.to_json
    end

    def self.load(hash)
      new(hash)
    end

    # Returns a list of the Virtus attributes in the model
    def self.fields
      attribute_set.entries.map(&:name)
    end
  end
end
