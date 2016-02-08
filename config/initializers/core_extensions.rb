require "core_extensions/i18n/handle_blank_value"
require "core_extensions/i18n/always_cascade"
require "core_extensions/dumb_delegator"

I18n.extend CoreExtensions::I18n::HandleBlankValue
I18n::Backend::Simple.send(:include, I18n::Backend::Cascade)
I18n.extend CoreExtensions::I18n::AlwaysCascade