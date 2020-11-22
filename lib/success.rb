# frozen_string_literal: true

require "service_result"

class Success < ServiceResult
  def success?
    true
  end
end
