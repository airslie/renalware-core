module Document
  module AttributeInitializer
    class Enum < Base
      def call
        yield name, type, options
        configure_enums
      end

      private

      def configure_enums
        enums = options[:enums] || Document::Enum.default_enums(klass.model_name, name)
        klass.enumerize name, in: enums
      end
    end
  end
end