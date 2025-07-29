# frozen_string_literal: true

class Shared::DateCell < Shared::TableCell
  attr_private_initialize :date_like

  def view_template = super { I18n.l(date_like.to_date) }
end
