# frozen_string_literal: true

module Enumerize
  class ValuePresenter < SimpleDelegator
    def to_s
      text
    end
  end
end
