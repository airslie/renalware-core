require "document/attribute_initializer/base"
require "document/attribute_initializer/active_model"
require "document/attribute_initializer/enum"

module Document
  module AttributeInitializer

    def self.determine_initializer(klass, name, type, options)
      initializer_class = build_class(type)
      initializer_class.new(klass, name, type, options)
    end

    def self.build_class(type)
      case
      when type == Document::Enum
        AttributeInitializer::Enum
      when type && type.included_modules.include?(::ActiveModel::Model)
        AttributeInitializer::ActiveModel
      else
        AttributeInitializer::Base
      end
    end

    private_class_method :build_class
  end
end
