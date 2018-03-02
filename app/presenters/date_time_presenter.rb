# frozen_string_literal: true

class DateTimePresenter < SimpleDelegator
  def to_s
    ::I18n.l self
  end
end
