# frozen_string_literal: true

class Shared::DateCell < Shared::TableCell
  def initialize(date_like)
    @date_like = date_like
    super()
  end

  def view_template
    super { I18n.l(date_like.to_date) }
  end

  private

  attr_reader :date_like
end
