module CoreExtensions
  module I18n
    module HandleBlankValue
      def localize(object, options = nil)
        object.blank? ? "" : super
      end
      alias :l :localize
    end
  end
end