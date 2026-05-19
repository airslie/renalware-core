# frozen_string_literal: true

module DocumentTranslations
  def document_t(document, attr_name)
    I18n.t(
      attr_name.to_sym,
      scope: "activemodel.attributes.#{document.class.name.underscore}"
    )
  end
end
