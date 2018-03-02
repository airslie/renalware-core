# frozen_string_literal: true

class TimePresenter < SimpleDelegator
  def to_s
    ::I18n.l self
  end
end
