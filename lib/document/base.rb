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

    # Flag an old attribute to be ignored
    # when the document is deserialized from the database
    #
    #   class RecipientWorkupDocument < Document::Base
    #     old_attribute :hx_tb
    #   end
    def self.old_attribute(attribute)
      @@methods_to_ignore ||= []
      @@methods_to_ignore << attribute
      @@methods_to_ignore << "#{attribute}=".to_sym
    end

    # Flag a list of old attribtues to be ignored
    # when the document is deserialized from the database
    #
    #   class RecipientWorkupDocument < Document::Base
    #     old_attributes :hx_tb, :hx_tb_date, :foo_bar
    #   end
    def self.old_attributes(*list)
      list.each { |item| old_attribute(item) }
    end

    def method_missing(method_sym, *arguments, &block)
      super unless @@methods_to_ignore.include? method_sym
    end
  end
end
