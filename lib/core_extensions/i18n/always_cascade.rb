# Enables cascading I18n definitions
#
# Example:
#
# en:
#   welcome: Gidday!
#
# Without cascading:

# I18n.translate("greetings.welcome") # => "translation missing: en.greetings.welcome"
#
# With cascading:
#
# I18n.translate("greetings.welcome") # => "Gidday!"
#
# For more information:
# http://svenfuchs.com/2011/2/11/organizing-translations-with-i18n-cascade-and-i18n-missingtranslations
#
module CoreExtensions
  module I18n
    module AlwaysCascade
      def translate(key, options = {})
        super(key, options.merge({ cascade: { offset: 2, skip_root: false } }))
      end
      alias :t :translate
    end
  end
end