# frozen_string_literal: true

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
      # Note changing offset from 2 to 1 causes errors in validates_timeliness gem in
      # #format_error_value where it tries to lookup I18n.t(:date)
      # It is actually trying to find the key :date in the scope
      # "validates_timeliness.error_value_formats" but this does not exist so, becuase of the
      # cascade, it settles on returning the root :date key which is actually a hash, and fails.
      # Using offset: 2 prevents us from ever picking up the root :date key when using t(:date)
      # or t(".date_"). It does mean we cannot put any translations under eg :en-GB directly, they
      # must be under a sub key eg :thead, :btn etc.
      # offset: 2 means we will be looking back up the tree for e.g. "list.type" if the key is
      # :type and the partial is called 'list', so we would never find eg the translation
      # renalware.type; offset: 1 and using skip_root: false seems to do the trick.
      # See the loop in lib/i18n/backend/cascade.rb in the i18n gem.
      # Another issue here is that if offset is 1 then any input called eg f.input :date
      # could resolve to the root :date tranlsation which is a hash of options and not a real
      # translation, leading to errors. Its not possible rename/reloacte these keys as they
      # are hard-coded eg in actionview/lib/action_view/helpers/date_helper.rb
      def translate(key, options = {})
        super(key, **options.merge(cascade: { offset: 2, skip_root: true }))
      end
      alias t translate
    end
  end
end
