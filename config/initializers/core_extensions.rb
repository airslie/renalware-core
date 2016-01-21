require "core_extensions/i18n/handle_blank_value"
require "core_extensions/i18n/always_cascade"

I18n.extend CoreExtensions::I18n::HandleBlankValue
I18n::Backend::Simple.send(:include, I18n::Backend::Cascade)
I18n.extend CoreExtensions::I18n::AlwaysCascade