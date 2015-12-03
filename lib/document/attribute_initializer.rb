require "document/attribute_initializer/base"
require "document/attribute_initializer/simple"
require "document/attribute_initializer/active_model"
require "document/attribute_initializer/enum"

module Document
  module AttributeInitializer

    def self.determine_initializer(klass, name, type, options)
      initializer_class = case
      when type == Document::Enum
        AttributeInitializer::Enum
      when type && type.included_modules.include?(::ActiveModel::Model)
        AttributeInitializer::ActiveModel
      else
        AttributeInitializer::Simple
      end
      initializer_class.new(klass, name, type, options)
    end

  end
end
